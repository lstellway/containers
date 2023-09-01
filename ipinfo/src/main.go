package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"strings"
)

type IpResponse struct {
	IP   string `json:"ip,omitempty"`
	Port string `json:"port,omitempty"`
}

func main() {
	http.HandleFunc("/", ipHandler)
	log.Fatal(http.ListenAndServe(":"+getListenPort(), nil))
}

/**
 * Handle request
 */
func ipHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	ip, port := getIp(r)

	data := IpResponse{
		IP:   ip,
		Port: port,
	}

	json.NewEncoder(w).Encode(data)
}

/**
 * Get listen port
 */
func getListenPort() string {
	port := os.Getenv("APP_PORT")

	if port == "" {
		port = "8080"
	}

	fmt.Printf("Listening on port %v\n", port)

	return port
}

/**
 * Get client IP address / port
 */
func getIp(r *http.Request) (string, string) {
	ip := r.Header.Get("X-Forwarded-For")
	var port string = ""

	// Get IP string
	if ip != "" {
		ips := strings.Split(ip, ",")
		ip = strings.Trim(ips[0], ", ")
	} else {
		ip = r.RemoteAddr
	}

	// Get position of the last colon
	i := strings.LastIndex(ip, ":")

	// If there is a colon and it is not part of an IPv6 address
	if i > 0 && ip[i-1:i] != ":" {
		return ip[:i], ip[i+1:]
	}

	return ip, port
}
