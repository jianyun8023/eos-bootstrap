# Sunshine keyboard regression cases

Run these against the rendered configuration with the upstream keyd 2.6.0
`test-io` harness (built from its `t/test-io.c` and core sources):

```sh
/path/to/keyd/bin/test-io /etc/keyd/sunshine.conf tests/keyd/*.t
```

The harness exercises the key state machine without accessing input devices.

Test device selection separately on Linux, using the same upstream sources:

```sh
cc -DDATA_DIR='""' -iquote /path/to/keyd/src -o /tmp/keyd-device-match \
  tests/keyd/device-match.c /path/to/keyd/src/{keyboard,string,macro,config,log,ini,keys,unicode}.c
/tmp/keyd-device-match /etc/keyd/sunshine.conf /etc/keyd/default.conf
```

This checks that only the Sunshine keyboard is remapped and that its relative
mouse, absolute mouse, touch and pen bypass both configurations.
