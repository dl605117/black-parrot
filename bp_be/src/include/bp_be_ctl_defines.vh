`ifndef BP_BE_CTL_DEFINES_VH
`define BP_BE_CTL_DEFINES_VH

/* int_fu_op [2:0] is equivalent to funct3 in the RV instruction.
 * int_fu_op [3] is an alternate version of that operation.
 */
// TODO: Think more carefully about these encodings
typedef enum logic [4:0]
{
  e_int_op_add        = 5'b00000
  ,e_int_op_sub       = 5'b01000
  ,e_int_op_sll       = 5'b00001
  ,e_int_op_slt       = 5'b00010
  ,e_int_op_sge       = 5'b01010
  ,e_int_op_sltu      = 5'b00011
  ,e_int_op_sgeu      = 5'b01011
  ,e_int_op_xor       = 5'b00100
  ,e_int_op_eq        = 5'b01100
  ,e_int_op_srl       = 5'b00101
  ,e_int_op_sra       = 5'b01101
  ,e_int_op_or        = 5'b00110
  ,e_int_op_ne        = 5'b01110
  ,e_int_op_and       = 5'b00111
  ,e_int_op_pass_src2 = 5'b01111
} bp_be_int_fu_op_e;

typedef enum logic [4:0]
{
  e_lb     = 5'b00000
  ,e_lh    = 5'b00001
  ,e_lw    = 5'b00010
  ,e_ld    = 5'b00011
  ,e_lbu   = 5'b00100
  ,e_lhu   = 5'b00101
  ,e_lwu   = 5'b00110

  ,e_sb    = 5'b01000
  ,e_sh    = 5'b01001
  ,e_sw    = 5'b01010
  ,e_sd    = 5'b01011

  ,e_lrw   = 5'b00111
  ,e_scw   = 5'b01100

  ,e_lrd   = 5'b01101
  ,e_scd   = 5'b01110
  ,e_fencei = 5'b01111
} bp_be_mmu_fu_op_e;

typedef enum logic [4:0]
{
  e_op_fadd      = 5'b00000
  ,e_op_fsub     = 5'b00001
  ,e_op_fmul     = 5'b00010
  ,e_op_fmin     = 5'b00011
  ,e_op_fmax     = 5'b00100
  ,e_op_fmadd    = 5'b00101
  ,e_op_fmsub    = 5'b00110
  ,e_op_fnmsub   = 5'b00111
  ,e_op_fnmadd   = 5'b01000
  ,e_op_i2f      = 5'b01001
  ,e_op_iu2f     = 5'b01010
  ,e_op_fsgnj    = 5'b01011
  ,e_op_fsgnjn   = 5'b01100
  ,e_op_fsgnjx   = 5'b01101
  ,e_op_feq      = 5'b01110
  ,e_op_flt      = 5'b01111
  ,e_op_fle      = 5'b10000
  ,e_op_fclass   = 5'b10001
  ,e_op_f2i      = 5'b10010
  ,e_op_f2iu     = 5'b10011
  ,e_op_f2f      = 5'b10100
  ,e_op_imvf     = 5'b10101
  ,e_op_fmvi     = 5'b10110
  ,e_op_fdiv     = 5'b11110
  ,e_op_fsqrt    = 5'b11111
} bp_be_fp_fu_op_e;

typedef enum logic [4:0]
{
  e_csrrw   = 5'b00001
  ,e_csrrs  = 5'b00010
  ,e_csrrc  = 5'b00011
  ,e_csrrwi = 5'b00100
  ,e_csrrsi = 5'b00101
  ,e_csrrci = 5'b00110

  // TODO: Separate out CSR op from exceptions based on flag
  ,e_ecall      = 5'b00111
  ,e_dret       = 5'b10011
  ,e_mret       = 5'b01000
  ,e_sret       = 5'b01001
  ,e_ebreak     = 5'b01010
  ,e_sfence_vma = 5'b01011
  ,e_wfi        = 5'b01100

  // We treat FE exceptions as CSR ops
  ,e_op_take_interrupt     = 5'b11000
  ,e_op_instr_access_fault = 5'b11001
  ,e_op_instr_page_fault   = 5'b11010
  ,e_op_instr_misaligned   = 5'b11011
  ,e_op_illegal_instr      = 5'b11111
  ,e_itlb_fill             = 5'b11100
} bp_be_csr_fu_op_e;

typedef enum logic [4:0]
{
  e_mul_op_mul        = 5'b00000
  ,e_mul_op_div       = 5'b00001
  ,e_mul_op_divu      = 5'b00010
  ,e_mul_op_rem       = 5'b00011
  ,e_mul_op_remu      = 5'b00100
} bp_be_mul_fu_op_e;

typedef struct packed
{
  union packed
  {
    bp_be_int_fu_op_e int_fu_op;
    bp_be_fp_fu_op_e  fp_fu_op;
    bp_be_mmu_fu_op_e mmu_fu_op;
    bp_be_csr_fu_op_e csr_fu_op;
    bp_be_mul_fu_op_e mul_fu_op;
  }  fu_op;
}  bp_be_fu_op_s;

typedef enum logic
{
  e_src1_is_rs1 = 1'b0
  ,e_src1_is_pc = 1'b1
} bp_be_src1_e;

typedef enum logic
{
  e_src2_is_rs2  = 1'b0
  ,e_src2_is_imm = 1'b1
} bp_be_src2_e;

typedef enum logic
{
  e_baddr_is_pc   = 1'b0
  ,e_baddr_is_rs1 = 1'b1
} bp_be_baddr_e;

typedef enum logic
{
  e_offset_is_imm   = 1'b0
  ,e_offset_is_zero = 1'b1
} bp_be_offset_e;

typedef enum logic [1:0]
{
  e_result_from_alu       = 2'b00
  ,e_result_from_pc_plus4 = 2'b01
  ,e_result_from_fpu_int  = 2'b11
} bp_be_result_e;

typedef enum logic
{
  e_pr_single  = 1'b0
  ,e_pr_double = 1'b1
} bp_be_fp_pr_e;

typedef struct packed
{
  logic                             queue_v;
  logic                             instr_v;

  logic                             pipe_comp_v;
  logic                             pipe_int_v;
  logic                             pipe_aux_v;
  logic                             pipe_mem_v;
  logic                             pipe_mul_v;
  logic                             pipe_fp_v;
  logic                             pipe_long_v;

  logic                             irf_w_v;
  logic                             frf_w_v;
  logic                             fflags_w_v;
  logic                             mem_v;
  logic                             dcache_r_v;
  logic                             dcache_w_v;
  logic                             csr_w_v;
  logic                             csr_r_v;
  logic                             csr_v;
  logic                             serial_v;
  logic                             frs1_v;
  logic                             frs2_v;
  logic                             frs3_v;
  logic                             jmp_v;
  logic                             br_v;
  logic                             opw_v;

  bp_be_fu_op_s                     fu_op;
  bp_be_fp_pr_e                     ipr;
  bp_be_fp_pr_e                     opr;

  bp_be_src1_e                      src1_sel;
  bp_be_src2_e                      src2_sel;
  bp_be_baddr_e                     baddr_sel;
  bp_be_offset_e                    offset_sel;
  bp_be_result_e                    result_sel;
}  bp_be_decode_s;

typedef struct packed
{
  // RISC-V exceptions
  logic store_page_fault;
  logic reserved2;
  logic load_page_fault;
  logic instr_page_fault;
  logic ecall_m_mode;
  logic reserved1;
  logic ecall_s_mode;
  logic ecall_u_mode;
  logic store_fault;
  logic store_misaligned;
  logic load_fault;
  logic load_misaligned;
  logic breakpoint;
  logic illegal_instr;
  logic instr_fault;
  logic instr_misaligned;
}  bp_be_ecode_dec_s;

`define bp_be_ecode_dec_width \
  ($bits(bp_be_ecode_dec_s))

typedef struct packed
{
  // BE exceptional conditions
  logic nop_v;
  logic poison_v;
  logic roll_v;
}  bp_be_exception_s;

`define bp_be_fu_op_width                                                                          \
  (`BSG_MAX($bits(bp_be_int_fu_op_e), `BSG_MAX($bits(bp_be_mmu_fu_op_e), $bits(bp_be_csr_fu_op_e))))

`define bp_be_decode_width                                                                         \
  ($bits(bp_be_decode_s))

`define bp_be_exception_width                                                                      \
  ($bits(bp_be_exception_s))

`endif

