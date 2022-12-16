#ifndef CSOURCES_BUILD_SAFE_LIB_WASM_H_GENERATED_
#define CSOURCES_BUILD_SAFE_LIB_WASM_H_GENERATED_
/* Automically generated by wasm2c */
#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>

#include "wasm-rt.h"

#ifndef WASM_RT_MODULE_PREFIX
#define WASM_RT_MODULE_PREFIX
#endif

#define WASM_RT_PASTE_(x, y) x ## y
#define WASM_RT_PASTE(x, y) WASM_RT_PASTE_(x, y)
#define WASM_RT_ADD_PREFIX(x) WASM_RT_PASTE(WASM_RT_MODULE_PREFIX, x)

/* TODO(binji): only use stdint.h types in header */
typedef uint8_t u8;
typedef int8_t s8;
typedef uint16_t u16;
typedef int16_t s16;
typedef uint32_t u32;
typedef int32_t s32;
typedef uint64_t u64;
typedef int64_t s64;
typedef float f32;
typedef double f64;

extern void WASM_RT_ADD_PREFIX(init)(void);

/* export: 'memory' */
extern wasm_rt_memory_t (*WASM_RT_ADD_PREFIX(Z_memory));
/* export: '_initialize' */
extern void (*WASM_RT_ADD_PREFIX(Z__initializeZ_vv))(void);
/* export: '__indirect_function_table' */
extern wasm_rt_table_t (*WASM_RT_ADD_PREFIX(Z___indirect_function_table));
/* export: '__errno_location' */
extern u32 (*WASM_RT_ADD_PREFIX(Z___errno_locationZ_iv))(void);
/* export: 'stackSave' */
extern u32 (*WASM_RT_ADD_PREFIX(Z_stackSaveZ_iv))(void);
/* export: 'stackRestore' */
extern void (*WASM_RT_ADD_PREFIX(Z_stackRestoreZ_vi))(u32);
/* export: 'stackAlloc' */
extern u32 (*WASM_RT_ADD_PREFIX(Z_stackAllocZ_ii))(u32);
#ifdef __cplusplus
}
#endif

#endif  /* CSOURCES_BUILD_SAFE_LIB_WASM_H_GENERATED_ */

// wasmbox_* API
// TODO: optional prefixing
extern void wasmbox_init(void);