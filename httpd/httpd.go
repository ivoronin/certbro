package main

import (
  "flag"
  "net/http"
)

const CHALLENGE_PREFIX = "/.well-known/acme-challenge/"
const DEFAULT_WEBROOT = "/webroot"

func main() {
	var webRoot = flag.String("webroot", DEFAULT_WEBROOT, "path to webroot directory")
	flag.Parse()
	fs := http.FileServer(http.Dir(*webRoot))
	http.Handle(CHALLENGE_PREFIX, fs)
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		target := "https://" + r.Host + r.URL.Path
		if len(r.URL.RawQuery) > 0 {
			target += "?" + r.URL.RawQuery
		}
		http.Redirect(w, r, target, http.StatusTemporaryRedirect)
	})
	http.ListenAndServe(":8080", nil)
}
