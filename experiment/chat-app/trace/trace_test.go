package trace

import (
	"bytes"
	"testing"
)

func TestNew(t *testing.T) {
	t.Error("we haven't written our test yet")

	var buf bytes.Buffer
	tracer := New(&buf)
	if tracer == nil {
		t.Error("Return from new should not be nil")
	} else {
		tracer.Trace("Hello trace package")
		if buf.String() != "Hello Trace Package. \n" {
			t.Errorf("Trace should not write '%s'.", buf.String())
		}
	}
}
