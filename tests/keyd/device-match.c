#include "keyd.h"

int main(int argc, char **argv)
{
    static struct config sunshine;
    static struct config fallback;
    const char *pointer_ids[] = {
        "beef:dead:2f1394ab", /* relative mouse */
        "beef:dead:ccac3c54", /* absolute mouse */
        "beef:dead:9ad4449e", /* touch */
        "beef:dead:97ce1366", /* pen */
    };

    if (argc != 3 || config_parse(&sunshine, argv[1]) ||
        config_parse(&fallback, argv[2]))
        return 1;

    assert(config_check_match(&sunshine, "beef:dead:fe1a1126", ID_KEYBOARD) == 2);
    assert(config_check_match(&fallback, "beef:dead:fe1a1126", ID_KEYBOARD) == 0);
    assert(config_check_match(&sunshine, "0001:0001:6fb3735a", ID_KEYBOARD) == 0);
    assert(config_check_match(&fallback, "0001:0001:6fb3735a", ID_KEYBOARD) == 1);
    for (size_t i = 0; i < ARRAY_SIZE(pointer_ids); i++) {
        /* Pointer devices advertise keys too: k: alone does not exclude them. */
        assert(config_check_match(&sunshine, pointer_ids[i], ID_MOUSE | ID_KEY) == 0);
        assert(config_check_match(&fallback, pointer_ids[i], ID_MOUSE | ID_KEY) == 0);
    }
    puts("Sunshine keyboard and pointer device matching PASSED");
    return 0;
}
