#include <stdio.h>
#include <Carbon/Carbon.h>
#include <stdlib.h>
#include <yaml.h>
#include <stdlib.h>
#include <limits.h>

#define MAX_HOTKEYS 9

static const int number_to_keycode[] = {
    [1] = kVK_ANSI_1,
    [2] = kVK_ANSI_2,
    [3] = kVK_ANSI_3,
    [4] = kVK_ANSI_4,
    [5] = kVK_ANSI_5,
    [6] = kVK_ANSI_6,
    [7] = kVK_ANSI_7,
    [8] = kVK_ANSI_8,
    [9] = kVK_ANSI_9,
};

typedef struct {
    int keyCode;
    char *path;
} cmd_hotkey;

cmd_hotkey hotkeys[MAX_HOTKEYS];

void parse_hotkeys() {
    int hotkey_count = 0;

    yaml_parser_t p;
    yaml_event_t e;

    char *home = getenv("HOME");
    char path[PATH_MAX];
    sprintf(path, "%s/.config/wimc/config.yaml", home);

    FILE *file = fopen(path, "r");
    yaml_parser_initialize(&p);
    yaml_parser_set_input_file(&p, file);

    char key[10] = "";
    while (yaml_parser_parse(&p, &e)) {
        switch (e.type) {
            case YAML_SCALAR_EVENT:
                if (strcmp("shortcuts", (char *) e.data.scalar.value) == 0) {
                    break;
                }

                if (key[0] == 0) {
                    strcpy(key, (char *) e.data.scalar.value);
                } else {
                    if (strcmp("keyCode", key) == 0) {
                        hotkeys[hotkey_count].keyCode = atoi((char *) e.data.scalar.value);
                    } else if (strcmp("dir", key) == 0) {
                        hotkeys[hotkey_count].path = malloc(strlen((char *) e.data.scalar.value) + 1);
                        strcpy(hotkeys[hotkey_count].path, (char *) e.data.scalar.value);

                        hotkey_count++;
                    }

                    key[0] = 0;
                }

                break;
            default:
                break;
        }

        if (e.type == YAML_STREAM_END_EVENT) {
            yaml_event_delete(&e);
            break;
        }

        yaml_event_delete(&e);
    }

    yaml_parser_delete(&p);
    fclose(file);
}

void register_hotkeys() {
    for (int i = 0; i < MAX_HOTKEYS; i++) {
        cmd_hotkey hotkey = hotkeys[i];
        EventHotKeyID hotKeyID = {
            .id = i
        };

        EventHotKeyRef hotKeyRef = NULL;
        OSStatus status = RegisterEventHotKey(
                number_to_keycode[hotkey.keyCode],
                cmdKey,
                hotKeyID,
                GetApplicationEventTarget(),
                kEventHotKeyNoOptions,
                &hotKeyRef
                );
    }
}

static OSStatus hotKeyHandler(
    EventHandlerCallRef nextHandler,
    EventRef event,
    void *userData
) {
    EventHotKeyID hotKeyID;
    OSStatus status = GetEventParameter(
        event,
        kEventParamDirectObject,
        typeEventHotKeyID,
        NULL,
        sizeof(EventHotKeyID),
        NULL,
        &hotKeyID
    );

    if (status != noErr) {
        return status;
    }

    cmd_hotkey hotkey = hotkeys[hotKeyID.id];

    char command[1024];
    sprintf(command, "osascript %s", hotkey.path);
    system(command);

    return noErr;
}

void init_event_handler() {
    EventTypeSpec hotKeyEvent = {
        kEventClassKeyboard,
        kEventHotKeyPressed
    };

    InstallApplicationEventHandler(
        hotKeyHandler,
        1,
        &hotKeyEvent,
        NULL,
        NULL
    );

    printf("listening for cmd+(1-9), press ctrl-c to quit\n");
    while (1) {
        EventRef event = NULL;
        OSStatus status = ReceiveNextEvent(
            0,
            NULL,
            kEventDurationForever,
            true,
            &event
        );

        if (status == noErr && event != NULL) {
            SendEventToEventTarget(event, GetEventDispatcherTarget());
            ReleaseEvent(event);
        }
    }
}

int main(void) {
    parse_hotkeys();
    register_hotkeys();
    init_event_handler();

    return 0;
}
