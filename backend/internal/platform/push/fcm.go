package push

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"time"
)

type FCMClient struct {
	serverKey string
	projectID string
	client    *http.Client
}
type FCMMessage struct {
	Message struct {
		Token        string `json:"token"`
		Notification struct {
			Title string `json:"title"`
			Body  string `json:"body"`
		} `json:"notification"`
		Data    map[string]string `json:"data,omitempty"`
		Android struct {
			Priority string `json:"priority"`
			TTL      string `json:"ttl"`
		} `json:"android,omitempty"`
		APNS struct {
			Headers map[string]string `json:"headers,omitempty"`
			Payload struct {
				Aps struct {
					Priority int `json:"priority"`
				} `json:"aps"`
			} `json:"payload,omitempty"`
		} `json:"apns,omitempty"`
	} `json:"message"`
}
type FCMResponse struct {
	Name  string `json:"name"`
	Error string `json:"error"`
}

func NewFCMClient(serverKey, projectID string) *FCMClient {
	return &FCMClient{serverKey: serverKey, projectID: projectID, client: &http.Client{Timeout: 10 * time.Second}}
}
func (c *FCMClient) Send(ctx context.Context, token, title, body string, data map[string]string, priority string) (string, error) {
	msg := FCMMessage{}
	msg.Message.Token = token
	msg.Message.Notification.Title = title
	msg.Message.Notification.Body = body
	msg.Message.Data = data
	msg.Message.Android.Priority = "high"
	msg.Message.Android.TTL = "14400s"
	if priority != "high" {
		msg.Message.Android.Priority = "normal"
		msg.Message.APNS.Headers = map[string]string{"apns-priority": "5"}
		msg.Message.APNS.Payload.Aps.Priority = 5
	}
	bodyBytes, err := json.Marshal(msg)
	if err != nil {
		return "", err
	}
	req, err := http.NewRequestWithContext(ctx, "POST", "https://fcm.googleapis.com/v1/projects/"+c.projectID+"/messages:send", bytes.NewReader(bodyBytes))
	if err != nil {
		return "", err
	}
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Authorization", "Bearer "+c.serverKey)
	resp, err := c.client.Do(req)
	if err != nil {
		return "", fmt.Errorf("FCM HTTP error: %w", err)
	}
	defer resp.Body.Close()
	var fcmResp FCMResponse
	_ = json.NewDecoder(resp.Body).Decode(&fcmResp)
	if resp.StatusCode != http.StatusOK {
		return "", fmt.Errorf("FCM error %d: %s", resp.StatusCode, fcmResp.Error)
	}
	return fcmResp.Name, nil
}
func (c *FCMClient) SendDryRun(ctx context.Context, token, title, body string, data map[string]string) (string, error) {
	msg := FCMMessage{}
	msg.Message.Token = token
	msg.Message.Notification.Title = title
	msg.Message.Notification.Body = body
	msg.Message.Data = data
	msg.Message.Android.Priority = "high"
	bodyBytes, err := json.Marshal(msg)
	if err != nil {
		return "", err
	}
	req, err := http.NewRequestWithContext(ctx, "POST", "https://fcm.googleapis.com/v1/projects/"+c.projectID+"/messages:send", bytes.NewReader(bodyBytes))
	if err != nil {
		return "", err
	}
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Authorization", "Bearer "+c.serverKey)
	req.Header.Set("dry_run", "true")
	resp, err := c.client.Do(req)
	if err != nil {
		return "", fmt.Errorf("FCM dry-run HTTP error: %w", err)
	}
	defer resp.Body.Close()
	var fcmResp FCMResponse
	_ = json.NewDecoder(resp.Body).Decode(&fcmResp)
	if resp.StatusCode != http.StatusOK {
		return "", fmt.Errorf("FCM dry-run error %d: %s", resp.StatusCode, fcmResp.Error)
	}
	return fcmResp.Name, nil
}
