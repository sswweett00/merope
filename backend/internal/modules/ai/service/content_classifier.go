package service

import (
	"context"
	"math"
	"regexp"
	"strings"
	"time"
	"unicode"

	ai_domain "local/merope/internal/modules/ai/domain"
)

type ContentClassifier struct {
	toxicityKeywords  map[string]float64
	sentimentKeywords map[string]float64
	nsfwPatterns      []*regexp.Regexp
	spamPatterns      []string
	honeypotPatterns  []string
	categoryKeywords  map[string][]string
	emotionKeywords   map[string][]string
}

func NewContentClassifier() *ContentClassifier {
	return &ContentClassifier{
		toxicityKeywords: map[string]float64{
			"hate": 0.6, "kill": 0.7, "stupid": 0.3, "idiot": 0.5,
			"trash": 0.4, "garbage": 0.3, "worthless": 0.5,
			"ugly": 0.2, "loser": 0.5, "disgusting": 0.6,
			"rape": 0.9, "murder": 0.9, "terrorist": 0.8,
			"nigger": 0.9, "faggot": 0.9, "retard": 0.7,
			"cunt": 0.8, "cock": 0.7, "piss": 0.4,
			"shit": 0.5, "bitch": 0.5, "dick": 0.5,
			"damn": 0.2, "hell": 0.2, "asshole": 0.6,
			"bastard": 0.5, "slut": 0.7, "whore": 0.7,
			"fuck": 0.4, "fucked": 0.4, "fucker": 0.5,
		},
		sentimentKeywords: map[string]float64{
			"love": 0.8, "great": 0.7, "amazing": 0.8, "happy": 0.7,
			"excellent": 0.8, "wonderful": 0.8, "beautiful": 0.7,
			"awesome": 0.8, "fantastic": 0.8, "brilliant": 0.7,
			"terrible": -0.7, "horrible": -0.8, "hate": -0.6,
			"awful": -0.8, "disgusting": -0.7, "ugly": -0.5,
			"sad": -0.5, "angry": -0.6, "mad": -0.5,
			"good": 0.5, "bad": -0.5, "nice": 0.5,
			"cool": 0.4, "fun": 0.5, "joy": 0.7,
			"excited": 0.7, "boring": -0.4, "worst": -0.7,
			"best": 0.8, "perfect": 0.9, "flop": -0.6,
		},
		nsfwPatterns: []*regexp.Regexp{
			regexp.MustCompile(`(?i)\b(nude|naked|porn|pornography|sex|sexy|pornhub|xnxx|xvideos|erotic|adult|hot\sex)\b`),
			regexp.MustCompile(`(?i)\b(\d{3,}\s*(?:cm|inch|inch|ft|lbs|kg|bra|cup))\b`),
		},
		spamPatterns: []string{
			"click here", "free money", "win prize", "limited time",
			"act now", "buy now", "discount code", "congratulations",
			"you have won", "claim your", "double your", "make money",
			"extra income", "work from home", "no experience",
			"guaranteed", "risk free", "urgent", "apply now",
			"as seen on", "hurry limited", "call now", "text stop",
		},
		honeypotPatterns: []string{
			"http://spam-test.invalid", "www.example-spam.com",
			"test@example.com", "placeholdertext",
		},
		categoryKeywords: map[string][]string{
			"tech":          {"tech", "technology", "software", "programming", "code", "developer", "ai", "ml", "app"},
			"politics":      {"politics", "government", "election", "vote", "senator", "president", "law", "policy"},
			"sports":        {"sports", "game", "score", "team", "player", "match", "win", "champion"},
			"entertainment": {"movie", "music", "celebrity", "hollywood", "show", "film", "actor", "concert"},
			"business":      {"business", "market", "stock", "invest", "startup", "company", "revenue"},
			"health":        {"health", "medical", "doctor", "hospital", "disease", "fitness", "wellness"},
			"food":          {"food", "cooking", "recipe", "restaurant", "chef", "delicious", "meal"},
			"travel":        {"travel", "vacation", "hotel", "destination", "trip", "adventure", "explore"},
		},
		emotionKeywords: map[string][]string{
			"joy":      {"happy", "love", "great", "awesome", "wonderful", "delight", "cheerful", "excited", "glad"},
			"anger":    {"angry", "furious", "mad", "rage", "outraged", "disgusted", "frustrated"},
			"sadness":  {"sad", "depressed", "unhappy", "gloomy", "mourn", "heartbroken", "lonely"},
			"fear":     {"scared", "afraid", "terrified", "anxious", "worried", "panic", "horror"},
			"surprise": {"surprised", "shocked", "wow", "unbelievable", "incredible", "astonishing"},
		},
	}
}

func (c *ContentClassifier) Classify(ctx context.Context, id, contentType, text, mediaURL string) (*ai_domain.ContentAnalysis, error) {
	analysis := &ai_domain.ContentAnalysis{
		ID:           id,
		TargetID:     id,
		ContentType:  contentType,
		ModelVersion: "v1.0.0",
		CreatedAt:    time.Now(),
		Categories:   map[string]float64{},
		Sentiment: ai_domain.SentimentResult{
			Emotions: map[string]float64{},
		},
	}

	if text == "" && mediaURL == "" {
		analysis.ToxicityScore = 0
		analysis.Confidence = 0.1
		return analysis, nil
	}

	toxicityScore := c.calculateToxicity(text)
	analysis.ToxicityScore = math.Min(toxicityScore, 1.0)

	sentiment := c.calculateSentiment(text)
	analysis.Sentiment = sentiment

	categories := c.detectCategories(text)
	analysis.Categories = categories

	nsfwLevel := c.detectNSFW(text, mediaURL)
	if nsfwLevel > 0.5 {
		analysis.Categories["nsfw"] = nsfwLevel
	}

	spamScore := c.detectSpam(text)
	if spamScore > 0.5 {
		analysis.Categories["spam"] = spamScore
		if analysis.ToxicityScore < spamScore {
			analysis.ToxicityScore = spamScore
		}
	}

	analysis.Confidence = c.calculateConfidence(analysis, text)

	return analysis, nil
}

func (c *ContentClassifier) ExtractEntities(ctx context.Context, text string) []ai_domain.EntityMention {
	entities := []ai_domain.EntityMention{}

	mentionRegex := regexp.MustCompile(`@(\w{1,30})`)
	mentions := mentionRegex.FindAllStringSubmatch(text, -1)
	for _, m := range mentions {
		entities = append(entities, ai_domain.EntityMention{
			ID:         m[1],
			EntityType: "mention",
			EntityID:   m[1],
			Text:       m[0],
			Confidence: 0.95,
		})
	}

	hashtagRegex := regexp.MustCompile(`#(\w{1,50})`)
	hashtags := hashtagRegex.FindAllStringSubmatch(text, -1)
	for _, h := range hashtags {
		entities = append(entities, ai_domain.EntityMention{
			ID:         h[1],
			EntityType: "hashtag",
			EntityID:   h[1],
			Text:       h[0],
			Confidence: 0.9,
		})
	}

	urlRegex := regexp.MustCompile(`https?://[^\s<>()"]+`)
	urls := urlRegex.FindAllString(text, -1)
	for _, url := range urls {
		entities = append(entities, ai_domain.EntityMention{
			ID:         url,
			EntityType: "url",
			EntityID:   url,
			Text:       url,
			Confidence: 0.99,
		})
	}

	return entities
}

func (c *ContentClassifier) calculateToxicity(text string) float64 {
	if text == "" {
		return 0
	}

	lowerText := strings.ToLower(text)
	words := strings.Fields(lowerText)
	if len(words) == 0 {
		return 0
	}

	totalScore := 0.0
	matchCount := 0

	for _, word := range words {
		cleaned := strings.TrimFunc(word, func(r rune) bool {
			return !unicode.IsLetter(r) && !unicode.IsDigit(r)
		})
		if cleaned == "" {
			continue
		}
		if score, ok := c.toxicityKeywords[cleaned]; ok {
			totalScore += score
			matchCount++
		}
	}

	if matchCount == 0 {
		return 0
	}

	avgScore := totalScore / float64(matchCount)
	amplification := math.Min(float64(matchCount)/10.0, 1.0)

	return avgScore * (0.5 + amplification*0.5)
}

func (c *ContentClassifier) calculateSentiment(text string) ai_domain.SentimentResult {
	if text == "" {
		return ai_domain.SentimentResult{Score: 0, Magnitude: 0, Emotions: map[string]float64{}}
	}

	lowerText := strings.ToLower(text)
	words := strings.Fields(lowerText)

	sentimentScore := 0.0
	sentimentCount := 0
	emotionScores := map[string]float64{}

	for _, word := range words {
		cleaned := strings.TrimFunc(word, func(r rune) bool {
			return !unicode.IsLetter(r) && !unicode.IsDigit(r)
		})
		if cleaned == "" {
			continue
		}
		if score, ok := c.sentimentKeywords[cleaned]; ok {
			sentimentScore += score
			sentimentCount++
		}
	}

	for emotion, keywords := range c.emotionKeywords {
		emotionScore := 0.0
		for _, keyword := range keywords {
			if strings.Contains(lowerText, keyword) {
				emotionScore += 0.3
			}
		}
		if emotionScore > 0 {
			emotionScores[emotion] = math.Min(emotionScore, 1.0)
		}
	}

	if sentimentCount == 0 {
		return ai_domain.SentimentResult{Score: 0, Magnitude: 0, Emotions: emotionScores}
	}

	avgSentiment := sentimentScore / float64(sentimentCount)
	magnitude := math.Abs(avgSentiment) * math.Min(float64(sentimentCount)/5.0, 1.0)

	return ai_domain.SentimentResult{
		Score:     math.Max(-1.0, math.Min(1.0, avgSentiment)),
		Magnitude: magnitude,
		Emotions:  emotionScores,
	}
}

func (c *ContentClassifier) detectCategories(text string) map[string]float64 {
	categories := map[string]float64{}
	lowerText := strings.ToLower(text)

	for category, keywords := range c.categoryKeywords {
		matchCount := 0
		for _, keyword := range keywords {
			if strings.Contains(lowerText, keyword) {
				matchCount++
			}
		}
		if matchCount > 0 {
			categories[category] = math.Min(float64(matchCount)/float64(len(keywords)), 1.0)
		}
	}

	return categories
}

func (c *ContentClassifier) detectNSFW(text, mediaURL string) float64 {
	score := 0.0
	lowerText := strings.ToLower(text)

	for _, pattern := range c.nsfwPatterns {
		if pattern.MatchString(lowerText) {
			score += 0.4
		}
	}

	if mediaURL != "" {
		lowerURL := strings.ToLower(mediaURL)
		nsfwIndicators := []string{"nsfw", "adult", "porn", "explicit", "nsfw_content"}
		for _, indicator := range nsfwIndicators {
			if strings.Contains(lowerURL, indicator) {
				score += 0.5
			}
		}
	}

	return math.Min(score, 1.0)
}

func (c *ContentClassifier) detectSpam(text string) float64 {
	lowerText := strings.ToLower(text)
	score := 0.0

	for _, pattern := range c.spamPatterns {
		if strings.Contains(lowerText, pattern) {
			score += 0.3
		}
	}

	for _, pattern := range c.honeypotPatterns {
		if strings.Contains(lowerText, pattern) {
			score += 0.2
		}
	}

	wordCount := float64(len(strings.Fields(text)))
	if wordCount > 0 && wordCount < 5 && strings.Contains(lowerText, "http") {
		score += 0.3
	}

	capsRatio := 0.0
	for _, r := range text {
		if unicode.IsUpper(r) {
			capsRatio++
		}
	}
	if wordCount > 0 && capsRatio/wordCount > 0.7 {
		score += 0.2
	}

	return math.Min(score, 1.0)
}

func (c *ContentClassifier) calculateConfidence(analysis *ai_domain.ContentAnalysis, text string) float64 {
	if text == "" {
		return 0.1
	}

	wordCount := float64(len(strings.Fields(text)))
	baseConfidence := math.Min(wordCount/100.0, 0.7)

	categoryCount := float64(len(analysis.Categories))
	categoryBonus := math.Min(categoryCount*0.1, 0.2)

	toxicitySignal := 0.0
	if analysis.ToxicityScore > 0.3 {
		toxicitySignal = 0.1
	}

	confidence := baseConfidence + categoryBonus + toxicitySignal
	return math.Min(confidence, 1.0)
}
