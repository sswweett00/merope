package push

import (
	"bytes"
	"context"
	"crypto/tls"
	"encoding/json"
	"fmt"
	"net/http"
	"time"
)

type APNSClient struct {
	bundleID string
	teamID   string
	keyID    string
	key      string
	client   *http.Client
}

type APNSMessage struct {
	Aps struct {
		Alert            string `json:"alert,omitempty"`
		Sound            string `json:"sound,omitempty"`
		Badge            int    `json:"badge,omitempty"`
		Category         string `json:"category,omitempty"`
		ThreadID         string `json:"thread-id,omitempty"`
		ContentAvailable int    `json:"content-available,omitempty"`
	} `json:"aps"`
	CustomData map[string]string `json:"custom_data,omitempty"`
}

func NewAPNSClient(bundleID, teamID, keyID, key string) *APNSClient {
	return &APNSClient{
		bundleID: bundleID,
		teamID:   teamID,
		keyID:    keyID,
		key:      key,
		client: &http.Client{
			Timeout: 10 * time.Second,
			Transport: &http.Transport{
				TLSClientConfig: &tls.Config{},
			},
		},
	}
}

func (c *APNSClient) Send(ctx context.Context, deviceToken, title, body string, data map[string]string, priority string) (string, error) {
	host := "https://api.push.apple.com"
	if priority != "high" {
		host = "https://api.development.push.apple.com"
	}

	payload := APNSMessage{}
	payload.Aps.Alert = title + ": " + body
	payload.Aps.Sound = "default"
	payload.Aps.Badge = 1
	payload.CustomData = data

	if priority == "high" {
		payload.Aps.ContentAvailable = 1
	}

	payloadBytes, err := json.Marshal(payload)
	if err != nil {
		return "", err
	}

	path := fmt.Sprintf("%s/3/device/%s", host, deviceToken)
	req, err := http.NewRequestWithContext(ctx, "POST", path, bytes.NewReader(payloadBytes))
	if err != nil {
		return "", err
	}

	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("apns-topic", c.bundleID)
	req.Header.Set("apns-push-type", "alert")
	if priority == "high" {
		req.Header.Set("apns-priority", "10")
	} else {
		req.Header.Set("apns-priority", "5")
	}

	resp, err := c.client.Do(req)
	if err != nil {
		return "", fmt.Errorf("APNs HTTP error: %w", err)
	}
	defer resp.Body.Close()

	respBody, _ := json.Marshal(map[string]interface{}{})
	json.NewDecoder(resp.Body).Decode(&respBody)

	if resp.StatusCode != http.StatusOK && resp.StatusCode != http.StatusAccepted {
		return "", fmt.Errorf("APNs error %d: %s", resp.StatusCode, string(respBody))
	}

	return "apns-" + deviceToken, nil
}

func (c *APNSClient) SendDryRun(ctx context.Context, deviceToken, title, body string, data map[string]string) (string, error) {
	payload := APNSMessage{}
	payload.Aps.Alert = title + ": " + body
	payload.Aps.Sound = "default"

	payloadBytes, err := json.Marshal(payload)
	if err != nil {
		return "", err
	}

	req, err := http.NewRequestWithContext(ctx, "POST", "https://api.push.apple.com/3/device/"+deviceToken, bytes.NewReader(payloadBytes))
	if err != nil {
		return "", err
	}
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("apns-topic", c.bundleID)
	req.Header.Set("apns-push-type", "alert")
	req.Header.Set("apns-priority", "10")
	req.Header.Set("apns-sandbox", "true")

	resp, err := c.client.Do(req)
	if err != nil {
		return "", fmt.Errorf("APNs dry-run HTTP error: %w", err)
	}
	defer resp.Body.Close()

	respBody, _ := json.Marshal(map[string]interface{}{})
	json.NewDecoder(resp.Body).Decode(&respBody)

	if resp.StatusCode != http.StatusOK {
		return "", fmt.Errorf("APNs dry-run error %d", resp.StatusCode)
	}

	return "apns-" + deviceToken, nil
}
