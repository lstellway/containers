package main

import (
	"context"
	"log"
	"os"
	"strings"

	"github.com/cloudflare/cloudflare-go"
)

func main() {
	// Validate
	err := validate()
	if err != nil {
		log.Fatal(err.Error() + "\n")
		return
	}

	// Get IP address
	ip, err := getIp()
	if err != nil {
		log.Fatal(err.Error() + "\n")
		return
	}

	// Init CloudFlare API
	api, err := cloudflare.NewWithAPIToken(os.Getenv("CF_API_TOKEN"))
	if err != nil {
		log.Fatal("Could not initialize CloudFlare API.\n")
		return
	}

	// Create records
	records := strings.Split(os.Getenv("CF_RECORD_NAME"), ",")
	for _, r := range records {
		setDnsRecord(api, strings.Trim(r, " "), ip)
	}
}

/**
 * Point A record to IP address
 */
func setDnsRecord(api *cloudflare.API, name string, ip string) {
	zoneId := os.Getenv("CF_ZONE_ID")
	zoneInfo := cloudflare.ZoneIdentifier(zoneId)

	// Find matching DNS records
	listDnsParams := cloudflare.ListDNSRecordsParams{
		Name: name,
	}
	records, result, err := api.ListDNSRecords(context.Background(), zoneInfo, listDnsParams)
	if err != nil {
		log.Fatal(err)
		return
	}

	if result.Count > 0 {
		// Update existing record
		updateDnsParams := cloudflare.UpdateDNSRecordParams{
			ID: records[0].ID,
			Content: ip,
		}

		_, err := api.UpdateDNSRecord(context.Background(), zoneInfo, updateDnsParams)
		reportResult("update", err)
	} else {
		// Create a new DNS record
		proxied := true
		createDnsParams := cloudflare.CreateDNSRecordParams{
			Type: "A",
			Name: name,
			Content: ip,
			Proxiable: true,
			Proxied: &proxied,
		}

		_, err := api.CreateDNSRecord(context.Background(), zoneInfo, createDnsParams)
		reportResult("create", err)
	}
}

/**
 * Report result
 */
func reportResult(action string, e error) {
	if e != nil {
		log.Fatal("Was not able to " + action + " DNS record.\n" + e.Error() + "\n")
	} else {
		log.Println("Successfully " + action + "d DNS record.")
	}
}
