package main

import (
	"encoding/json"
	"errors"
	"io"
	"net/http"
	"os"
)

type IpInfo struct {
	IP   string `json:"ip,omitempty"`
	Port string `json:"port,omitempty"`
}

/**
 * Get IP address
 */
func getIp() (string, error) {
	// Fetch URL
	resp, err := http.Get(os.Getenv("DDNS_URL"))
	if err != nil {
		return "", errors.New("Could not retrieve IP info.")
	}
	defer resp.Body.Close()

	// Read response body
	data, err := io.ReadAll(resp.Body)
	if err != nil {
		return "", errors.New("Could not read response body.")
	}

	// Parse JSON
	ipinfo := IpInfo{}
	err = json.Unmarshal(data, &ipinfo)
	if err != nil {
		return "", errors.New("Could not parse JSON data.")
	}

	return ipinfo.IP, nil
}
