## DDNS for CloudFlare

Script written in Go to set DNS records for host in CloudFlare.
This is meant to be used in tandem with the [IPInfo server](https://github.com/lstellway/containers/tree/development/ipinfo), however it should be able to work fine with other compatible API's (that return a JSON object with an `ip` property, such as [ipinfo.io](https://ipinfo.io/json)).

## Docker

**Image**

```sh
docker pull ghcr.io/lstellway/ddns-cloudflare
```

**Environment Variables**

-   `DDNS_URL` - URL to IP info API (eg. [IPInfo server](https://github.com/lstellway/containers/tree/development/ipinfo))
-   `CF_API_TOKEN` - CloudFlare API token
-   `CF_ZONE_ID` - CloudFlare zone ID
-   `CF_RECORD_NAME` - Comma-separated list of record names (eg. `subdomain.example.com,subdomain1.example.com`)
