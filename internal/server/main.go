package manifoldserver

import (
	"fmt"
	"net/http"
)

// Start will start a local http server
func Start() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Hello, you've requested: %s\n", r.URL.Path)
	})

	http.ListenAndServe(":8080", nil)
}

// Sum adds a and b together and returns the result
func Sum(a int, b int) int {
	return a + b
}
