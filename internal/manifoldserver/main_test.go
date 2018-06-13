package manifoldserver

import "testing"

func TestSum(t *testing.T) {
	sum := Sum(1, 5)

	if sum != 6 {
		t.Errorf("Sum was incorrect, got: %d, want: %d.", sum, 6)
	}
}
