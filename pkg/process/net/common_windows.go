// +build windows

package net

const (
	statusURL      = "http://localhost:3333/status"
	connectionsURL = "http://localhost:3333/connections"
	statsURL       = "http://localhost:3333/debug/stats"
	netType        = "tcp"
)

// SetSystemProbePath provides a unix socket path location to be used by the remote system probe.
// This needs to be called before GetRemoteSystemProbeUtil.
func SetSystemProbePath(path string) {
	globalPath = path
}

// CheckPath is used in conjunction with calling the stats endpoint, since we are calling this
// From the main agent and want to ensure the socket exists
func CheckPath() error {
	if globalPath == "" {
		return fmt.Errorf("remote tracer has no path defined")
	}
	return nil
}
