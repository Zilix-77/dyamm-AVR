# Debugging — Status: TBD

> Per `AGENTS.md`: record only errors actually encountered, with fixes that worked.

## Known issues (verified)

- Root `README.md` was UTF-16 LE; file tools treated it as binary — rewrote as UTF-8.

## Incident: SIGSEGV in malloc arena on vivo V2430 (arm64, Android 15)

- Symptom: `Fatal signal 11 (SIGSEGV), code SEGV_ACCERR` on the main thread, pc in
  `[anon:libc_malloc]`, single-frame tombstone, after running the TEMP self-test.
  Three tombstones captured (`tombstone_14/15/16`).
- Forensics: `ndk-stack -sym` against the unstripped `libsimavr_jni.so` yielded no
  frames (broken stack); no simavr frames in sibling threads.
- Outcome: not reproduced — 5 consecutive on-device PASS runs of current builds.
  Leading theory remains a mixed/stale install (MissingPluginException era), not an
  emulator defect. Tombstone procedure that works here: `adb pull /data/tombstones`
  + `ndk-stack -sym build/.../obj/<abi>`.
- Regression gates added (portable, no device conditionals): CMake
  `-Werror=pointer-to-int-cast -Werror=int-to-pointer-cast` plus `_Static_assert`
  handle-width checks in `simavr_jni.c`. Verified passing under NDK 28 Clang.
- Note: this device's logcat does not deliver app-UID logs; on-device evidence came
  from UI screenshots + `adb exec-out screencap`. TEMP `TLOG`/`debugPrint` markers
  exist for any recurrence.

## Process (Phase 1+)

Log here: symptom → cause → fix → verified command. No speculative entries.
