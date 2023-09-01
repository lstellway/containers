package main

import (
	"errors"
	"os"
)

/**
 * Check dependencies
 */
func validate() error {
	if os.Getenv("DDNS_URL") == "" {
		return errors.New("\"DDNS_URL\" environment variable is not set.")
	}

	if os.Getenv("CF_API_TOKEN") == "" {
		return errors.New("\"CF_API_TOKEN\" environment variable is not set.")
	}

	if os.Getenv("CF_ZONE_ID") == "" {
		return errors.New("\"CF_ZONE_ID\" environment variable is not set.")
	}

	if os.Getenv("CF_RECORD_NAME") == "" {
		return errors.New("\"CF_RECORD_NAME\" environment variable is not set.")
	}

	return nil
}
