  let buildArgsList;

// `modulePromise` is a promise to the `WebAssembly.module` object to be
//   instantiated.
// `importObjectPromise` is a promise to an object that contains any additional
//   imports needed by the module that aren't provided by the standard runtime.
//   The fields on this object will be merged into the importObject with which
//   the module will be instantiated.
// This function returns a promise to the instantiated module.
export const instantiate = async (modulePromise, importObjectPromise) => {
    let dartInstance;

      function stringFromDartString(string) {
        const totalLength = dartInstance.exports.$stringLength(string);
        let result = '';
        let index = 0;
        while (index < totalLength) {
          let chunkLength = Math.min(totalLength - index, 0xFFFF);
          const array = new Array(chunkLength);
          for (let i = 0; i < chunkLength; i++) {
              array[i] = dartInstance.exports.$stringRead(string, index++);
          }
          result += String.fromCharCode(...array);
        }
        return result;
    }

    function stringToDartString(string) {
        const length = string.length;
        let range = 0;
        for (let i = 0; i < length; i++) {
            range |= string.codePointAt(i);
        }
        if (range < 256) {
            const dartString = dartInstance.exports.$stringAllocate1(length);
            for (let i = 0; i < length; i++) {
                dartInstance.exports.$stringWrite1(dartString, i, string.codePointAt(i));
            }
            return dartString;
        } else {
            const dartString = dartInstance.exports.$stringAllocate2(length);
            for (let i = 0; i < length; i++) {
                dartInstance.exports.$stringWrite2(dartString, i, string.charCodeAt(i));
            }
            return dartString;
        }
    }

      // Converts a Dart List to a JS array. Any Dart objects will be converted, but
    // this will be cheap for JSValues.
    function arrayFromDartList(constructor, list) {
        const length = dartInstance.exports.$listLength(list);
        const array = new constructor(length);
        for (let i = 0; i < length; i++) {
            array[i] = dartInstance.exports.$listRead(list, i);
        }
        return array;
    }

    buildArgsList = function(list) {
        const dartList = dartInstance.exports.$makeStringList();
        for (let i = 0; i < list.length; i++) {
            dartInstance.exports.$listAdd(dartList, stringToDartString(list[i]));
        }
        return dartList;
    }

    // A special symbol attached to functions that wrap Dart functions.
    const jsWrappedDartFunctionSymbol = Symbol("JSWrappedDartFunction");

    function finalizeWrapper(dartFunction, wrapped) {
        wrapped.dartFunction = dartFunction;
        wrapped[jsWrappedDartFunctionSymbol] = true;
        return wrapped;
    }

    if (WebAssembly.String === undefined) {
        console.log("WebAssembly.String is undefined, adding polyfill");
        WebAssembly.String = {
            "charCodeAt": (s, i) => s.charCodeAt(i),
            "compare": (s1, s2) => {
                if (s1 < s2) return -1;
                if (s1 > s2) return 1;
                return 0;
            },
            "concat": (s1, s2) => s1 + s2,
            "equals": (s1, s2) => s1 === s2,
            "fromCharCode": (i) => String.fromCharCode(i),
            "length": (s) => s.length,
            "substring": (s, a, b) => s.substring(a, b),
        };
    }

    // Imports
    const dart2wasm = {

  _72: (x0,x1) => x0.querySelector(x1),
_12740: s => stringToDartString(JSON.stringify(stringFromDartString(s))),
_12741: s => console.log(stringFromDartString(s)),
_12844: o => o === undefined,
_12845: o => typeof o === 'boolean',
_12846: o => typeof o === 'number',
_12848: o => typeof o === 'string',
_12851: o => o instanceof Int8Array,
_12852: o => o instanceof Uint8Array,
_12853: o => o instanceof Uint8ClampedArray,
_12854: o => o instanceof Int16Array,
_12855: o => o instanceof Uint16Array,
_12856: o => o instanceof Int32Array,
_12857: o => o instanceof Uint32Array,
_12858: o => o instanceof Float32Array,
_12859: o => o instanceof Float64Array,
_12860: o => o instanceof ArrayBuffer,
_12861: o => o instanceof DataView,
_12862: o => o instanceof Array,
_12863: o => typeof o === 'function' && o[jsWrappedDartFunctionSymbol] === true,
_12867: (l, r) => l === r,
_12868: o => o,
_12869: o => o,
_12870: o => o,
_12871: b => !!b,
_12872: o => o.length,
_12875: (o, i) => o[i],
_12876: f => f.dartFunction,
_12877: l => arrayFromDartList(Int8Array, l),
_12878: l => arrayFromDartList(Uint8Array, l),
_12879: l => arrayFromDartList(Uint8ClampedArray, l),
_12880: l => arrayFromDartList(Int16Array, l),
_12881: l => arrayFromDartList(Uint16Array, l),
_12882: l => arrayFromDartList(Int32Array, l),
_12883: l => arrayFromDartList(Uint32Array, l),
_12884: l => arrayFromDartList(Float32Array, l),
_12885: l => arrayFromDartList(Float64Array, l),
_12886: (data, length) => {
          const view = new DataView(new ArrayBuffer(length));
          for (let i = 0; i < length; i++) {
              view.setUint8(i, dartInstance.exports.$byteDataGetUint8(data, i));
          }
          return view;
        },
_12887: l => arrayFromDartList(Array, l),
_12888: stringFromDartString,
_12896: (o, p) => o[p],
_12892: l => new Array(l),
_12900: o => String(o),
_12803: (o) => new DataView(o.buffer, o.byteOffset, o.byteLength),
_12753: (a, i) => a.push(i),
_12764: a => a.length,
_12766: (a, i) => a[i],
_12767: (a, i, v) => a[i] = v,
_12769: a => a.join(''),
_12779: (s, p, i) => s.indexOf(p, i),
_12782: (o, start, length) => new Uint8Array(o.buffer, o.byteOffset + start, length),
_12783: (o, start, length) => new Int8Array(o.buffer, o.byteOffset + start, length),
_12784: (o, start, length) => new Uint8ClampedArray(o.buffer, o.byteOffset + start, length),
_12785: (o, start, length) => new Uint16Array(o.buffer, o.byteOffset + start, length),
_12786: (o, start, length) => new Int16Array(o.buffer, o.byteOffset + start, length),
_12787: (o, start, length) => new Uint32Array(o.buffer, o.byteOffset + start, length),
_12788: (o, start, length) => new Int32Array(o.buffer, o.byteOffset + start, length),
_12791: (o, start, length) => new Float32Array(o.buffer, o.byteOffset + start, length),
_12792: (o, start, length) => new Float64Array(o.buffer, o.byteOffset + start, length),
_12794: WebAssembly.String.charCodeAt,
_12797: WebAssembly.String.length,
_12798: WebAssembly.String.equals,
_12799: WebAssembly.String.compare,
_12800: WebAssembly.String.fromCharCode,
_12807: Function.prototype.call.bind(Object.getOwnPropertyDescriptor(DataView.prototype, 'byteLength').get),
_12808: (b, o) => new DataView(b, o),
_12810: Function.prototype.call.bind(DataView.prototype.getUint8),
_12812: Function.prototype.call.bind(DataView.prototype.getInt8),
_12814: Function.prototype.call.bind(DataView.prototype.getUint16),
_12816: Function.prototype.call.bind(DataView.prototype.getInt16),
_12818: Function.prototype.call.bind(DataView.prototype.getUint32),
_12820: Function.prototype.call.bind(DataView.prototype.getInt32),
_12826: Function.prototype.call.bind(DataView.prototype.getFloat32),
_12828: Function.prototype.call.bind(DataView.prototype.getFloat64),
_12751: (c) =>
              queueMicrotask(() => dartInstance.exports.$invokeCallback(c)),
_12716: v => stringToDartString(v.toString()),
_12727: Date.now,
_12729: s => new Date(s * 1000).getTimezoneOffset() * 60 ,
_12731: () => {
          let stackString = new Error().stack.toString();
          let frames = stackString.split('\n');
          let drop = 2;
          if (frames[0] === 'Error') {
              drop += 1;
          }
          return frames.slice(drop).join('\n');
        },
_6842: (x0,x1) => x0.textContent = x1,
_6847: () => globalThis.document
      };

    const baseImports = {
        dart2wasm: dart2wasm,

  
          Math: Math,
        Date: Date,
        Object: Object,
        Array: Array,
        Reflect: Reflect,
    };
    dartInstance = await WebAssembly.instantiate(await modulePromise, {
        ...baseImports,
        ...(await importObjectPromise),
    });

    return dartInstance;
}

// Call the main function for the instantiated module
// `moduleInstance` is the instantiated dart2wasm module
// `args` are any arguments that should be passed into the main function.
export const invoke = (moduleInstance, ...args) => {
    const dartMain = moduleInstance.exports.$getMain();
    const dartArgs = buildArgsList(args);
    moduleInstance.exports.$invokeMain(dartMain, dartArgs);
}

