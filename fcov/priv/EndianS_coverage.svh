///////////////////////////////////////////
//
// RISC-V Architectural Functional Coverage Covergroups
//
// Written: Corey Hickson chickson@hmc.edu 20 November 2024
// 
// Copyright (C) 2024 Harvey Mudd College, 10x Engineers, UET Lahore, Habib University
//
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// Licensed under the Solderpad Hardware License v 2.1 (the “License”); you may not use this file 
// except in compliance with the License, or, at your option, the Apache License version 2.0. You 
// may obtain a copy of the License at
//
// https://solderpad.org/licenses/SHL-2.1/
//
// Unless required by applicable law or agreed to in writing, any work distributed under the 
// License is distributed on an “AS IS” BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, 
// either express or implied. See the License for the specific language governing permissions 
// and limitations under the License.
////////////////////////////////////////////////////////////////////////////////////////////////

`define COVER_ENDIANS
typedef RISCV_instruction #(ILEN, XLEN, FLEN, VLEN, NHART, RETIRE) ins_endians_t;

covergroup endians_cg with function sample(ins_endians_t ins);
    option.per_instance = 0; 
    // "Endianness tests in machine mode"

    // building blocks for the main coverpoints
        // ENDIANNESS COVERPOINTS: check writes and reads with various endianness
    cp_sw: coverpoint ins.current.insn {
        wildcard bins sw = {32'b????????????_?????_010_?????_0100011}; 
    }
    cp_sh: coverpoint ins.current.insn {
        wildcard bins sh = {32'b????????????_?????_001_?????_0100011}; 
    }
    cp_sb: coverpoint ins.current.insn {
        wildcard bins sb = {32'b????????????_?????_000_?????_0100011}; 
    }
    cp_lw: coverpoint ins.current.insn {
        wildcard bins lw = {32'b????????????_?????_010_?????_0000011}; 
    }
    cp_lh: coverpoint ins.current.insn {
        wildcard bins lh = {32'b????????????_?????_001_?????_0000011}; 
    }
    cp_lhu: coverpoint ins.current.insn {
        wildcard bins lhu = {32'b????????????_?????_101_?????_0000011}; 
    }
    cp_lb: coverpoint ins.current.insn {
        wildcard bins lb = {32'b????????????_?????_000_?????_0000011}; 
    }
    cp_lbu: coverpoint ins.current.insn {
        wildcard bins lbu = {32'b????????????_?????_100_?????_0000011}; 
    }
    cp_byteoffset: coverpoint ins.current.imm[2:0] iff (ins.current.rs1_val[2:0] == 3'b000) {
        // all byte offsets
    }
    cp_halfoffset: coverpoint ins.current.imm[2:1] iff (ins.current.rs1_val[2:0] == 3'b000 & ins.current.imm[0] == 1'b0)  {
        // all halfword offsets
    }    
    cp_wordoffset: coverpoint ins.current.imm[2] iff (ins.current.rs1_val[2:0] == 3'b000 & ins.current.imm[1:0] == 2'b00)  {
        // all word offsets
    }    
    `ifdef XLEN64
        mstatus_mbe: coverpoint ins.current.csr[12'h300][37] { // mbe is mstatus[37] in RV64
        }
    `else
        mstatus_mbe: coverpoint ins.current.csr[12'h310][5] { // mbe is mstatush[5] in RV32
        }
    `endif
    `ifdef XLEN64
        mstatus_sbe: coverpoint ins.current.csr[12'h300][36] { // sbe is mstatus[36] in RV64
        }
    `else
        mstatus_sbe: coverpoint ins.current.csr[12'h310][4] { // sbe is mstatush[4] in RV32
        }
    `endif
    sstatus_ube: coverpoint ins.current.csr[12'h100][6] { // ube is mstatus[6]
    }
    priv_mode_m: coverpoint ins.current.mode { 
       bins M_mode = {2'b11};
    }   
    priv_mode_s: coverpoint ins.current.mode { 
       bins S_mode = {2'b01};
    }
    priv_mode_u: coverpoint ins.current.mode { 
       bins U_mode = {2'b00};
    }   
    mstatus_mprv: coverpoint ins.current.csr[12'h300][17] { // mprv is mstatus[17]
    }
    mstatus_mpp: coverpoint ins.current.csr[12'h300][12:11] { // mpp is mstatus[12:11]
        bins S_Mode = {2'b01};
        bins M_Mode = {2'b11};
    }
    // main coverpoints
    cp_sstatus_sbe_endianness_sw:  cross priv_mode_s, mstatus_sbe, cp_sw,  cp_wordoffset;
    cp_sstatus_sbe_endianness_sh:  cross priv_mode_s, mstatus_sbe, cp_sh,  cp_halfoffset;
    cp_sstatus_sbe_endianness_sb:  cross priv_mode_s, mstatus_sbe, cp_sb,  cp_byteoffset;
    cp_sstatus_sbe_endianness_lw:  cross priv_mode_s, mstatus_sbe, cp_lw,  cp_wordoffset;
    cp_sstatus_sbe_endianness_lh:  cross priv_mode_s, mstatus_sbe, cp_lh,  cp_halfoffset;
    cp_sstatus_sbe_endianness_lb:  cross priv_mode_s, mstatus_sbe, cp_lb,  cp_byteoffset;
    cp_sstatus_sbe_endianness_lhu: cross priv_mode_s, mstatus_sbe, cp_lhu, cp_halfoffset;
    cp_sstatus_sbe_endianness_lbu: cross priv_mode_s, mstatus_sbe, cp_lbu, cp_byteoffset;
    cp_mstatus_mprv_sbe_endianness_sw:  cross priv_mode_m, mstatus_sbe, cp_sw,  cp_wordoffset, mstatus_mprv, mstatus_mbe, mstatus_mpp;
    cp_mstatus_mprv_sbe_endianness_sh:  cross priv_mode_m, mstatus_sbe, cp_sh,  cp_halfoffset, mstatus_mprv, mstatus_mbe, mstatus_mpp;
    cp_mstatus_mprv_sbe_endianness_sb:  cross priv_mode_m, mstatus_sbe, cp_sb,  cp_byteoffset, mstatus_mprv, mstatus_mbe, mstatus_mpp;
    cp_mstatus_mprv_sbe_endianness_lw:  cross priv_mode_m, mstatus_sbe, cp_lw,  cp_wordoffset, mstatus_mprv, mstatus_mbe, mstatus_mpp;
    cp_mstatus_mprv_sbe_endianness_lh:  cross priv_mode_m, mstatus_sbe, cp_lh,  cp_halfoffset, mstatus_mprv, mstatus_mbe, mstatus_mpp;
    cp_mstatus_mprv_sbe_endianness_lb:  cross priv_mode_m, mstatus_sbe, cp_lb,  cp_byteoffset, mstatus_mprv, mstatus_mbe, mstatus_mpp;
    cp_mstatus_mprv_sbe_endianness_lhu: cross priv_mode_m, mstatus_sbe, cp_lhu, cp_halfoffset, mstatus_mprv, mstatus_mbe, mstatus_mpp;
    cp_mstatus_mprv_sbe_endianness_lbu: cross priv_mode_m, mstatus_sbe, cp_lbu, cp_byteoffset, mstatus_mprv, mstatus_mbe, mstatus_mpp;
    cp_sstatus_ube_endianness_sw:  cross priv_mode_u, sstatus_ube, cp_sw,  cp_wordoffset;
    cp_sstatus_ube_endianness_sh:  cross priv_mode_u, sstatus_ube, cp_sh,  cp_halfoffset;
    cp_sstatus_ube_endianness_sb:  cross priv_mode_u, sstatus_ube, cp_sb,  cp_byteoffset;
    cp_sstatus_ube_endianness_lw:  cross priv_mode_u, sstatus_ube, cp_lw,  cp_wordoffset;
    cp_sstatus_ube_endianness_lh:  cross priv_mode_u, sstatus_ube, cp_lh,  cp_halfoffset;
    cp_sstatus_ube_endianness_lb:  cross priv_mode_u, sstatus_ube, cp_lb,  cp_byteoffset;
    cp_sstatus_ube_endianness_lhu: cross priv_mode_u, sstatus_ube, cp_lhu, cp_halfoffset;
    cp_sstatus_ube_endianness_lbu: cross priv_mode_u, sstatus_ube, cp_lbu, cp_byteoffset;
    `ifdef XLEN64
        cp_sd: coverpoint ins.current.insn {
            wildcard bins sd = {32'b????????????_?????_011_?????_0100011}; 
        }
        cp_ld: coverpoint ins.current.insn {
            wildcard bins ld = {32'b????????????_?????_001_?????_0000011}; 
        }
        cp_lwu: coverpoint ins.current.insn {
            wildcard bins lwu = {32'b????????????_?????_110_?????_0000011}; 
        }
        cp_doubleoffset: coverpoint ins.current.imm[2:0] iff (ins.current.rs1_val[2:0] == 3'b000)  {
            bins zero = {3'b000};
        }
        cp_mstatus_mbe_endianness_sd:  cross priv_mode_s, mstatus_sbe, cp_sd,  cp_doubleoffset;
        cp_mstatus_mbe_endianness_ld:  cross priv_mode_s, mstatus_sbe, cp_ld,  cp_doubleoffset;
        cp_mstatus_mbe_endianness_lwu: cross priv_mode_s, mstatus_sbe, cp_lwu, cp_wordoffset;
        cp_mstatus_mpr_ube_endianness_sd:  cross priv_mode_s, mstatus_sbe, cp_sd, cp_doubleoffset, mstatus_mprv, mstatus_mbe, mstatus_mpp;
        cp_mstatus_mpr_ube_endianness_ld:  cross priv_mode_s, mstatus_sbe, cp_ld, cp_doubleoffset, mstatus_mprv, mstatus_mbe, mstatus_mpp;
        cp_mstatus_mpr_ube_endianness_lwu: cross priv_mode_s, mstatus_sbe, cp_lwu,  cp_wordoffset, mstatus_mprv, mstatus_mbe, mstatus_mpp;
        cp_sstatus_ube_endianness_sd:  cross priv_mode_u, sstatus_ube, cp_sd,  cp_doubleoffset;
        cp_sstatus_ube_endianness_ld:  cross priv_mode_u, sstatus_ube, cp_ld,  cp_doubleoffset;
        cp_sstatus_ube_endianness_lwu: cross priv_mode_u, sstatus_ube, cp_lwu, cp_wordoffset;
    `endif

endgroup

function void endians_sample(int hart, int issue);
    ins_endians_t ins;

    ins = new(hart, issue, traceDataQ); 
    ins.add_rd(0);
    ins.add_rs1(2);
    ins.add_csr(1);
    
    endians_cg.sample(ins);
    
endfunction