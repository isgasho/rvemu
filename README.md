# rvemu
[![Build Status](https://travis-ci.com/d0iasm/rvemu.svg?branch=master)](https://travis-ci.com/d0iasm/rvemu)
![Actions Status](https://github.com/d0iasm/rvemu/workflows/Build%20and%20Test/badge.svg)

RISC-V online emulator with WebAssembly generated by Rust. The instruction sets in this emulator complies "The RISC-V Instruction Set ManualVolume I: Unprivileged ISADocument Version 20191213".

The online emulator is available here: [rvemu.app](https://rvemu.app/)

Supports the following RISC-V ISA features (RV64G):
- RV32I (v2.1): supports 40/40 instructions (FENCE, ECALL, and EBREAK don't do anything for now)
- RV64I (v2.1): supports 12/12 instructions (SLLI, SRLI, and SRAI are included in RV32I)
- RV32M/RV64M (v2.0): supports 13/13 instructions
- RV32A/RV64A (v2.0): supports 22/22 instructions (no unittests and no atomicity)
- RV32F/RV64F (v2.2): supports 30/30 instructions
- RV32D/RV64D (v2.2): supports 32/32 instructions
- Zifencei (v2.0): supports 1/1 instructions (FENCE.i doesn't do anything for now)
- Zicsr (v2.0): supports 6/6 instructions (no unittests and no atomicity)

__NOTE: This project is currently under intensely development. The source code might be changed dramatically.__
What to do next is:
1. Rewrite tests in assembly or use
   [riscv/riscv-tests](https://github.com/riscv/riscv-tests)
2. devices interrupt (refers to
   [memlayout.h](https://github.com/mit-pdos/xv6-riscv/blob/37df68e5dedbf2a26c2bf0bdae090b206ce78b48/kernel/memlayout.h) in xv6)
   1. keyboards
   2. timer
   3. uart
   4. virtio
   5. block devices
3. virtual memory

# Usage
The emulator supports the following commands:
- __upload__: Upload a local RISC-V binary/local RISC-V binaries for an execution on the emulator.
- __ls__: List the files you uploaded.
- __run [file]__: Execute a file.
- __help__: Print all commands you can use.

![Demo](https://raw.githubusercontent.com/d0iasm/rvemu/master/demo.gif)

## Build and run on the local browser
The `wasm-pack build` command generates a pkg directory and makes Rust source code into `.wasm` binary. It also generates the JavaScript API for using our Rust-generated WebAssembly. The toolchain's supported target is `wasm32-unknown-unknown`.
You need to execute this command whenever you change your Rust code.
```
$ make rvemu-wasm
// This is the alias of `wasm-pack build lib/rvemu-wasm --out-dir <path-to-rvemu>/public/pkg --target web`.
```

This command installs dependencies in the `node_modules` directory. Need `npm install --save` in the `public` directory at the first time and whenever you change dependencies in package.json.
```
$ npm install --save // at the public directory
```

You can see the website via http://localhost:8000. `npm start` is the alias of `python3 -m http.server` so you need Python3 in your environment.
```
$ npm start // at the public directory
```

## Build and run as a CLI tool
The emulator can be executed as a CLI tool.
```
$ make rvemu-cli
// This is the alias of `cargo build --release --manifest-path lib/rvemu-cli/Cargo.toml`.
```

The binary file is generated in the target directory.
```
$ ./target/release/rvemu-cli <binary-file-name>
```

## Build RISC-V binary
This emulator starts to execute at the address 0, so you need to extract .text section to execute your binary file on the emulator.
```
// Make an assembly file from a C file.
$ riscv64-unknown-elf-gcc -S hoge.c -nostdlib
// Make a binary file from an assembly file with start position 0.
$ riscv64-unknown-elf-gcc -o hoge hoge.s -Wl,-Ttext=0 -nostdlib
// Extract a text section from a binary file.
$ riscv64-unknown-elf-objcopy -O binary --only-section=.text hoge hoge.text
```

## Testing
You need to install a Firefox browser, a Chrome browser, or a Safari browser to test the project. A browser can be specified by a `--firefox` or a `--chrome` flag.
```
$ make test
// This is the alias of `wasm-pack test lib/rvemu-wasm --headless --firefox`.
```

## Publish
[The site](https://rvemu.app/) is hosted by a firebase.
```
$ firebase deploy
```

# Roadmap
### Supports "The RISC-V Instruction Set ManualVolume I: Unprivileged ISADocument Version 20191213"
- [x] RV64G ISA
- [ ] RV64C ISA

### Supports "The RISC-V Instruction Set ManualVolume II: Privileged ArchitectureDocument Version 20190608-Priv-MSU-Ratified"
- [ ] Privileged ISA (URET, SRET, MRET, WFI, SFENCE.VMA, HFENCE.BVMA, and HFENCE.GVMA)
- [ ] Machine-level CSRs
- [ ] Machine-Mode privileged instructions
- [ ] Supervisor-level CSRs
- [ ] Supervisor instructions
- [ ] Page-Based Virtual-Memory System
- [ ] User-level CSRs

## Dependencies
- rust toolchain (rustup/rustc/cargo/cargo-generate)
- wasm-pack
- npm
  - [xterm](https://xtermjs.org/)
  - xterm-addon-fit
- firebase CLI

## Resources
### Documents
- [RISC-V Specifications](https://riscv.org/specifications/)
- [Rust and WebAssembly](https://rustwasm.github.io/docs/book/introduction.html)
- [riscv/riscv-sbi-doc](https://github.com/riscv/riscv-sbi-doc/blob/master/riscv-sbi.adoc)
- [riscv/riscv-elf-psabi-doc](https://github.com/riscv/riscv-elf-psabi-doc/blob/master/riscv-elf.md)
- [riscv/riscv-asm-manual](https://github.com/riscv/riscv-asm-manual/blob/master/riscv-asm.md)

### Implementation of other emulators
- [qemu/qemu](https://github.com/qemu/qemu)
- [riscv/riscv-isa-sim](https://github.com/riscv/riscv-isa-sim)
- [riscv/riscv-angel](https://github.com/riscv/riscv-angel)
- [riscv/riscv-ovpsim](https://github.com/riscv/riscv-ovpsim)
- [rv8-io/rv8](https://github.com/rv8-io/rv8)
- [TinyEmu](https://bellard.org/tinyemu/)
- [stephank/rvsim](https://github.com/stephank/rvsim)

### Helpful tools
- [riscv/riscv-tests](https://github.com/riscv/riscv-tests)
- [wat2wasm demo](https://webassembly.github.io/wabt/demo/wat2wasm/)
- [RISC-V Online Simulator](https://www.kvakil.me/venus/)

## Articles about this project
- [Emulate 32-Bit And 64-Bit RISC-V In Your Browser With Asami’s Open Source rvemu | Gareth Halfacree, Hackster.io](https://riscv.org/2020/01/emulate-32-bit-and-64-bit-risc-v-in-your-browser-with-asamis-open-source-rvemu-gareth-halfacree-hackster-io/)
- [Emulate 32-Bit and 64-Bit RISC-V in Your Browser with Asami's Open Source rvemu](https://www.hackster.io/news/emulate-32-bit-and-64-bit-risc-v-in-your-browser-with-asami-s-open-source-rvemu-b783f672e463)
