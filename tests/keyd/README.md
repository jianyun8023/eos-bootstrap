# Sunshine keyboard regression cases

Run these against the rendered configuration with the upstream keyd 2.6.0
`test-io` harness (built from its `t/test-io.c` and core sources):

```sh
/path/to/keyd/bin/test-io /etc/keyd/sunshine.conf tests/keyd/*.t
```

The harness exercises the key state machine without accessing input devices.
