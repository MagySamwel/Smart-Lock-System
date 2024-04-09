
;CodeVisionAVR C Compiler V3.52 
;(C) Copyright 1998-2023 Pavel Haiduc, HP InfoTech S.R.L.
;http://www.hpinfotech.ro

;Build configuration    : Debug
;Chip type              : ATmega16
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Mode 2
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU SPMCSR=0x37
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.EQU __FLASH_PAGE_SIZE=0x40

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETW1P
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __GETD1P_INC
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X+
	.ENDM

	.MACRO __GETD1P_DEC
	LD   R23,-X
	LD   R22,-X
	LD   R31,-X
	LD   R30,-X
	.ENDM

	.MACRO __PUTDP1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTDP1_DEC
	ST   -X,R23
	ST   -X,R22
	ST   -X,R31
	ST   -X,R30
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __CPD10
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	.ENDM

	.MACRO __CPD20
	SBIW R26,0
	SBCI R24,0
	SBCI R25,0
	.ENDM

	.MACRO __ADDD12
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	.ENDM

	.MACRO __ADDD21
	ADD  R26,R30
	ADC  R27,R31
	ADC  R24,R22
	ADC  R25,R23
	.ENDM

	.MACRO __SUBD12
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	SBC  R23,R25
	.ENDM

	.MACRO __SUBD21
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R25,R23
	.ENDM

	.MACRO __ANDD12
	AND  R30,R26
	AND  R31,R27
	AND  R22,R24
	AND  R23,R25
	.ENDM

	.MACRO __ORD12
	OR   R30,R26
	OR   R31,R27
	OR   R22,R24
	OR   R23,R25
	.ENDM

	.MACRO __XORD12
	EOR  R30,R26
	EOR  R31,R27
	EOR  R22,R24
	EOR  R23,R25
	.ENDM

	.MACRO __XORD21
	EOR  R26,R30
	EOR  R27,R31
	EOR  R24,R22
	EOR  R25,R23
	.ENDM

	.MACRO __COMD1
	COM  R30
	COM  R31
	COM  R22
	COM  R23
	.ENDM

	.MACRO __MULD2_2
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	.ENDM

	.MACRO __LSRD1
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	.ENDM

	.MACRO __LSLD1
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	.ENDM

	.MACRO __ASRB4
	ASR  R30
	ASR  R30
	ASR  R30
	ASR  R30
	.ENDM

	.MACRO __ASRW8
	MOV  R30,R31
	CLR  R31
	SBRC R30,7
	SER  R31
	.ENDM

	.MACRO __LSRD16
	MOV  R30,R22
	MOV  R31,R23
	LDI  R22,0
	LDI  R23,0
	.ENDM

	.MACRO __LSLD16
	MOV  R22,R30
	MOV  R23,R31
	LDI  R30,0
	LDI  R31,0
	.ENDM

	.MACRO __CWD1
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	.ENDM

	.MACRO __CWD2
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
	.ENDM

	.MACRO __SETMSD1
	SER  R31
	SER  R22
	SER  R23
	.ENDM

	.MACRO __ADDW1R15
	CLR  R0
	ADD  R30,R15
	ADC  R31,R0
	.ENDM

	.MACRO __ADDW2R15
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	.ENDM

	.MACRO __EQB12
	CP   R30,R26
	LDI  R30,1
	BREQ PC+2
	CLR  R30
	.ENDM

	.MACRO __NEB12
	CP   R30,R26
	LDI  R30,1
	BRNE PC+2
	CLR  R30
	.ENDM

	.MACRO __LEB12
	CP   R30,R26
	LDI  R30,1
	BRGE PC+2
	CLR  R30
	.ENDM

	.MACRO __GEB12
	CP   R26,R30
	LDI  R30,1
	BRGE PC+2
	CLR  R30
	.ENDM

	.MACRO __LTB12
	CP   R26,R30
	LDI  R30,1
	BRLT PC+2
	CLR  R30
	.ENDM

	.MACRO __GTB12
	CP   R30,R26
	LDI  R30,1
	BRLT PC+2
	CLR  R30
	.ENDM

	.MACRO __LEB12U
	CP   R30,R26
	LDI  R30,1
	BRSH PC+2
	CLR  R30
	.ENDM

	.MACRO __GEB12U
	CP   R26,R30
	LDI  R30,1
	BRSH PC+2
	CLR  R30
	.ENDM

	.MACRO __LTB12U
	CP   R26,R30
	LDI  R30,1
	BRLO PC+2
	CLR  R30
	.ENDM

	.MACRO __GTB12U
	CP   R30,R26
	LDI  R30,1
	BRLO PC+2
	CLR  R30
	.ENDM

	.MACRO __CPW01
	CLR  R0
	CP   R0,R30
	CPC  R0,R31
	.ENDM

	.MACRO __CPW02
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	.ENDM

	.MACRO __CPD12
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	.ENDM

	.MACRO __CPD21
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R25,R23
	.ENDM

	.MACRO __BSTB1
	CLT
	TST  R30
	BREQ PC+2
	SET
	.ENDM

	.MACRO __LNEGB1
	TST  R30
	LDI  R30,1
	BREQ PC+2
	CLR  R30
	.ENDM

	.MACRO __LNEGW1
	OR   R30,R31
	LDI  R30,1
	BREQ PC+2
	LDI  R30,0
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD2M
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CALL __GETW1Z
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CALL __GETD1Z
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __GETW2X
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __GETD2X
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _c=R5
	.DEF _curr_location=R6
	.DEF _curr_location_msb=R7
	.DEF _curr_num=R8
	.DEF _curr_num_msb=R9
	.DEF _first_run=R4
	.DEF _enter_password=R11
	.DEF _run_interrupt=R10
	.DEF __lcd_x=R13
	.DEF __lcd_y=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _admin_INT0
	JMP  _setPC_INT1
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G102:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G102:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x1,0x0,0x0,0x0
	.DB  0xFF,0xFF,0x0,0x0

_0x12:
	.DB  0xCB,0x0,0x81,0x0,0x45,0x1,0xAA,0x1
	.DB  0x4F,0x0,0xE7,0x3,0x6F,0x0,0x7E,0x0
	.DB  0x80,0x0,0x82,0x0,0x84,0x0,0xE7,0x3
	.DB  0x50,0x72,0x6F,0x66,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x41,0x68,0x6D,0x65
	.DB  0x64,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x41,0x6D,0x72,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x41,0x64,0x65,0x6C
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x4F,0x6D,0x61,0x72,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x4D,0x41,0x58,0x5F
	.DB  0x49,0x44,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
_0x0:
	.DB  0x50,0x72,0x65,0x73,0x73,0x20,0x2A,0x0
	.DB  0x50,0x6C,0x65,0x61,0x73,0x65,0x20,0x70
	.DB  0x72,0x65,0x73,0x73,0x20,0x2A,0x0,0x45
	.DB  0x6E,0x74,0x65,0x72,0x20,0x79,0x6F,0x75
	.DB  0x72,0x20,0x49,0x44,0x0,0x45,0x6E,0x74
	.DB  0x65,0x72,0x20,0x79,0x6F,0x75,0x72,0x20
	.DB  0x50,0x43,0x3A,0x0,0x57,0x65,0x6C,0x63
	.DB  0x6F,0x6D,0x65,0x2C,0x20,0x25,0x73,0x0
	.DB  0x53,0x6F,0x72,0x72,0x79,0x2C,0x20,0x77
	.DB  0x72,0x6F,0x6E,0x67,0x20,0x50,0x43,0x0
	.DB  0x57,0x72,0x6F,0x6E,0x67,0x20,0x49,0x44
	.DB  0x0,0x25,0x63,0x0,0x45,0x6E,0x74,0x65
	.DB  0x72,0x20,0x6F,0x6C,0x64,0x20,0x50,0x43
	.DB  0x20,0x3A,0x0,0x45,0x6E,0x74,0x65,0x72
	.DB  0x20,0x6E,0x65,0x77,0x20,0x50,0x43,0x20
	.DB  0x3A,0x0,0x43,0x6F,0x6E,0x74,0x61,0x63
	.DB  0x74,0x20,0x41,0x64,0x6D,0x69,0x6E,0x0
	.DB  0x52,0x65,0x2D,0x65,0x6E,0x74,0x65,0x72
	.DB  0x20,0x6E,0x65,0x77,0x20,0x50,0x43,0x0
	.DB  0x4E,0x65,0x77,0x20,0x50,0x43,0x20,0x73
	.DB  0x74,0x6F,0x72,0x65,0x64,0x0,0x50,0x43
	.DB  0x20,0x69,0x73,0x20,0x73,0x74,0x6F,0x72
	.DB  0x65,0x64,0x0,0x45,0x6E,0x74,0x65,0x72
	.DB  0x20,0x41,0x64,0x6D,0x69,0x6E,0x20,0x50
	.DB  0x43,0x0,0x45,0x6E,0x74,0x65,0x72,0x20
	.DB  0x53,0x74,0x75,0x64,0x65,0x6E,0x74,0x20
	.DB  0x49,0x44,0x0,0x45,0x6E,0x74,0x65,0x72
	.DB  0x20,0x6E,0x65,0x77,0x20,0x50,0x43,0x0
	.DB  0x25,0x64,0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x08
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x08
	.DW  _0x17
	.DW  _0x0*2

	.DW  0x0F
	.DW  _0x17+8
	.DW  _0x0*2+8

	.DW  0x01
	.DW  _0x1D
	.DW  _0x0*2+7

	.DW  0x0E
	.DW  _0x1D+1
	.DW  _0x0*2+23

	.DW  0x0F
	.DW  _0x1D+15
	.DW  _0x0*2+37

	.DW  0x10
	.DW  _0x1D+30
	.DW  _0x0*2+64

	.DW  0x09
	.DW  _0x1D+46
	.DW  _0x0*2+80

	.DW  0x01
	.DW  _0x2A
	.DW  _0x0*2+7

	.DW  0x0E
	.DW  _0x80
	.DW  _0x0*2+23

	.DW  0x0F
	.DW  _0x80+14
	.DW  _0x0*2+92

	.DW  0x0F
	.DW  _0x80+29
	.DW  _0x0*2+107

	.DW  0x0E
	.DW  _0x80+44
	.DW  _0x0*2+122

	.DW  0x0E
	.DW  _0x80+58
	.DW  _0x0*2+122

	.DW  0x10
	.DW  _0x85
	.DW  _0x0*2+136

	.DW  0x0E
	.DW  _0x85+16
	.DW  _0x0*2+122

	.DW  0x0E
	.DW  _0x85+30
	.DW  _0x0*2+152

	.DW  0x0D
	.DW  _0x88
	.DW  _0x0*2+166

	.DW  0x11
	.DW  _0x9F
	.DW  _0x0*2+194

	.DW  0x0D
	.DW  _0x9F+17
	.DW  _0x0*2+211

	.DW  0x0E
	.DW  _0x9F+30
	.DW  _0x0*2+122

	.DW  0x0E
	.DW  _0x9F+44
	.DW  _0x0*2+122

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0x00

	.DSEG
	.ORG 0x160

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;void initialize_pins();
;void enter_samples();
;void wait_asterisk();
;void mainPage();
;unsigned int read_lcd();
;unsigned char keypad();
;_Bool match_ID_PC(unsigned int id, unsigned int entered_passward);
;void set_passcode();
;void update_password(unsigned id);
;unsigned int get_passward(unsigned int id);
;void admin_update_password(unsigned int id, unsigned int new_passward);
;char* get_name(unsigned int id);
;_Bool exist(unsigned id);
;int get_id_location(unsigned int id);
;unsigned int check_flags(unsigned char curr_char);
;unsigned int get_nameLength(unsigned char ch);
;void admin_interaction();
;void handle_interrupt(_Bool check_password);
;void EE_Write(unsigned int address, unsigned char data);
;unsigned char EE_Read(unsigned int address);
;unsigned int store(char name[], unsigned int id, unsigned int password, unsigned int location);
;unsigned int store_number(unsigned int number, unsigned int location, _Bool ID_or_PC);
;unsigned int store_name(char name[], unsigned int location);
;unsigned int get_number(unsigned int location);
;char* get_name_fromEEPROM(unsigned int location);
;void error(int number_of_peeps, const char* message);
;unsigned int GetBit(unsigned int num, unsigned int idx);
;unsigned int SetBit1(unsigned int num, unsigned int idx);
;unsigned int SetBit0(unsigned int num, unsigned int idx);
;void open_door();
;void close_door();
;interrupt[2] void admin_INT0(void);
;interrupt[3] void setPC_INT1(void);
;void main(void)
; 0000 006A {

	.CSEG
_main:
; .FSTART _main
; 0000 006B initialize_pins();      // initialize pins (inputs and outputs)
	RCALL _initialize_pins
; 0000 006C enter_samples();        // add samples to be tested
	RCALL _enter_samples
; 0000 006D wait_asterisk();         // wait * to start the system
	RCALL _wait_asterisk
; 0000 006E }
_0x3:
	RJMP _0x3
; .FEND
;void initialize_pins()
; 0000 0072 {
_initialize_pins:
; .FSTART _initialize_pins
; 0000 0073 lcd_init(16);
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0000 0074 DDRC = 0b00000111;              // keypad port (3 outputs , 4 inputs , 1 unused)
	LDI  R30,LOW(7)
	OUT  0x14,R30
; 0000 0075 PORTC = 0b11111000;             // enable pull up resistance for input pins
	LDI  R30,LOW(248)
	OUT  0x15,R30
; 0000 0076 
; 0000 0077 DDRB = 0b0000011;               //motor pins (set them to be output)
	LDI  R30,LOW(3)
	OUT  0x17,R30
; 0000 0078 PORTB.0 = 1; PORTB.1 = 1;       // intialize the door to make it not moving
	SBI  0x18,0
	SBI  0x18,1
; 0000 0079 
; 0000 007A 
; 0000 007B DDRD.3 = 0;                     // set pc button pin (set the pin to be input)
	CBI  0x11,3
; 0000 007C PORTD.3 = 1;                    //Pullup
	SBI  0x12,3
; 0000 007D DDRD.2 = 0;                     //admin push-pull button pin
	CBI  0x11,2
; 0000 007E PORTD.2 = 1;                    //Pullup
	SBI  0x12,2
; 0000 007F 
; 0000 0080 DDRD.5 = 1;                     // activate sounder bit  (set it to be output)
	SBI  0x11,5
; 0000 0081 
; 0000 0082 SREG.7 = 1;                     // or #asm("sei")  => Enable global interrupt
	BSET 7
; 0000 0083 GICR |= (1 << 6);               // Enable EXT_INT0
	IN   R30,0x3B
	ORI  R30,0x40
	OUT  0x3B,R30
; 0000 0084 MCUCR |= (1 << 1);              // Falling edge EXT_INT0  MCUCR.1=1
	IN   R30,0x35
	ORI  R30,2
	OUT  0x35,R30
; 0000 0085 MCUCR &= ~(1 << 0);             // MCUCR.0=0;
	IN   R30,0x35
	ANDI R30,0xFE
	OUT  0x35,R30
; 0000 0086 
; 0000 0087 GICR |= (1 << 7);               //  Enable EXT_INT1
	IN   R30,0x3B
	ORI  R30,0x80
	OUT  0x3B,R30
; 0000 0088 MCUCR |= (1 << 3);              //  Falling edge EXT_INT1  MCUCR.3=1
	IN   R30,0x35
	ORI  R30,8
	OUT  0x35,R30
; 0000 0089 MCUCR &= ~(1 << 2);             //  MCUCR.2=0;
	IN   R30,0x35
	ANDI R30,0xFB
	OUT  0x35,R30
; 0000 008A }
	RET
; .FEND
;void enter_samples()
; 0000 008D {
_enter_samples:
; .FSTART _enter_samples
; 0000 008E 
; 0000 008F char names[][20] = { "Prof", "Ahmed", "Amr" ,"Adel" ,"Omar" , "MAX_ID" };
; 0000 0090 unsigned int ids[] = { 111, 126, 128 , 130 , 132 , 999 };
; 0000 0091 unsigned int passwords[] = { 203, 129, 325 , 426 ,79 , 999};
; 0000 0092 
; 0000 0093 unsigned int size = sizeof(names) / sizeof(names[0]);
; 0000 0094 int i = 0;
; 0000 0095 for (i = 0; i < size; i++)
	SBIW R28,63
	SBIW R28,63
	SBIW R28,18
	LDI  R24,144
	__GETWRN 22,23,0
	LDI  R30,LOW(_0x12*2)
	LDI  R31,HIGH(_0x12*2)
	RCALL __INITLOCB
	RCALL __SAVELOCR4
;	names -> Y+28
;	ids -> Y+16
;	passwords -> Y+4
;	size -> R16,R17
;	i -> R18,R19
	__GETWRN 16,17,6
	RCALL SUBOPT_0x0
_0x14:
	__CPWRR 18,19,16,17
	BRSH _0x15
; 0000 0096 {
; 0000 0097 curr_location = store(names[i], ids[i], passwords[i], curr_location);
	__MULBNWRU 18,19,20
	MOVW R26,R28
	ADIW R26,28
	ADD  R30,R26
	ADC  R31,R27
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R18
	MOVW R26,R28
	ADIW R26,18
	RCALL SUBOPT_0x1
	MOVW R30,R18
	MOVW R26,R28
	ADIW R26,8
	RCALL SUBOPT_0x1
	MOVW R26,R6
	RCALL _store
	MOVW R6,R30
; 0000 0098 }
	__ADDWRN 18,19,1
	RJMP _0x14
_0x15:
; 0000 0099 
; 0000 009A }
	RCALL __LOADLOCR4
	ADIW R28,63
	ADIW R28,63
	ADIW R28,22
	RET
; .FEND
;void wait_asterisk()
; 0000 009D {
_wait_asterisk:
; .FSTART _wait_asterisk
; 0000 009E if (!first_run)  // check it it's the first time to run the programe
	TST  R4
	BRNE _0x16
; 0000 009F {
; 0000 00A0 delay_ms(1000);
	RCALL SUBOPT_0x2
; 0000 00A1 lcd_clear();
; 0000 00A2 }
; 0000 00A3 first_run = false;
_0x16:
	CLR  R4
; 0000 00A4 lcd_printf("Press *");  strcpy(curr_lcd, "Press *");
	__POINTW1FN _0x0,0
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x4
	__POINTW2MN _0x17,0
	RCALL _strcpy
; 0000 00A5 while (1)
_0x18:
; 0000 00A6 {
; 0000 00A7 c = keypad();
	RCALL SUBOPT_0x5
; 0000 00A8 
; 0000 00A9 if (c == '*')
	BRNE _0x1B
; 0000 00AA {
; 0000 00AB mainPage();
	RCALL _mainPage
; 0000 00AC }
; 0000 00AD else
	RJMP _0x1C
_0x1B:
; 0000 00AE {
; 0000 00AF error(1, "Please press *");
	RCALL SUBOPT_0x6
	__POINTW2MN _0x17,8
	RCALL _error
; 0000 00B0 }
_0x1C:
; 0000 00B1 
; 0000 00B2 }
	RJMP _0x18
; 0000 00B3 }
; .FEND

	.DSEG
_0x17:
	.BYTE 0x17
;void mainPage()
; 0000 00B7 {

	.CSEG
_mainPage:
; .FSTART _mainPage
; 0000 00B8 unsigned int password = 0, id = 0;
; 0000 00B9 char* name = "";
; 0000 00BA lcd_clear();
	RCALL SUBOPT_0x7
;	password -> R16,R17
;	id -> R18,R19
;	*name -> R20,R21
	__POINTWRMN 20,21,_0x1D,0
	RCALL _lcd_clear
; 0000 00BB lcd_printf("Enter your ID");
	__POINTW1FN _0x0,23
	RCALL SUBOPT_0x3
; 0000 00BC lcd_gotoxy(0, 1);
	RCALL SUBOPT_0x8
; 0000 00BD strcpy(curr_lcd, "Enter your ID");  // save the current state of the lcd
	RCALL SUBOPT_0x4
	__POINTW2MN _0x1D,1
	RCALL _strcpy
; 0000 00BE 
; 0000 00BF id = read_lcd();
	RCALL SUBOPT_0x9
; 0000 00C0 
; 0000 00C1 if (exist(id))
	BREQ _0x1E
; 0000 00C2 {
; 0000 00C3 lcd_clear();
	RCALL SUBOPT_0xA
; 0000 00C4 enter_password=true;   // enable the password mode
; 0000 00C5 curr_num =-1;
; 0000 00C6 lcd_printf("Enter your PC:");
	__POINTW1FN _0x0,37
	RCALL SUBOPT_0x3
; 0000 00C7 strcpy(curr_lcd, "Enter your PC:");
	RCALL SUBOPT_0x4
	__POINTW2MN _0x1D,15
	RCALL _strcpy
; 0000 00C8 lcd_gotoxy(0, 1);
	RCALL SUBOPT_0x8
; 0000 00C9 
; 0000 00CA password = read_lcd();
	RCALL SUBOPT_0xB
; 0000 00CB if (match_ID_PC(id, password))
	BREQ _0x1F
; 0000 00CC {
; 0000 00CD name = get_name(id);
	MOVW R26,R18
	RCALL _get_name
	MOVW R20,R30
; 0000 00CE lcd_clear();
	RCALL _lcd_clear
; 0000 00CF lcd_printf("Welcome, %s", name);
	__POINTW1FN _0x0,52
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R20
	RCALL SUBOPT_0xC
; 0000 00D0 open_door();
	RCALL _open_door
; 0000 00D1 close_door();
	RCALL _close_door
; 0000 00D2 }
; 0000 00D3 else
	RJMP _0x20
_0x1F:
; 0000 00D4 {
; 0000 00D5 error(1, "Sorry, wrong PC");
	RCALL SUBOPT_0x6
	__POINTW2MN _0x1D,30
	RCALL _error
; 0000 00D6 }
_0x20:
; 0000 00D7 }
; 0000 00D8 else
	RJMP _0x21
_0x1E:
; 0000 00D9 {
; 0000 00DA error(2, "Wrong ID");
	RCALL SUBOPT_0xD
	__POINTW2MN _0x1D,46
	RCALL _error
; 0000 00DB }
_0x21:
; 0000 00DC wait_asterisk();
	RCALL _wait_asterisk
; 0000 00DD }
	RCALL __LOADLOCR6
	RJMP _0x2080005
; .FEND

	.DSEG
_0x1D:
	.BYTE 0x37
;unsigned int read_lcd()
; 0000 00E1 {

	.CSEG
_read_lcd:
; .FSTART _read_lcd
; 0000 00E2 unsigned int num = 0, curr_digit = 0, three_digit = 0, col = 0;
; 0000 00E3 
; 0000 00E4 c = ' ';
	SBIW R28,2
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	RCALL SUBOPT_0x7
;	num -> R16,R17
;	curr_digit -> R18,R19
;	three_digit -> R20,R21
;	col -> Y+6
	__GETWRN 20,21,0
	LDI  R30,LOW(32)
	MOV  R5,R30
; 0000 00E5 while (three_digit < 3)
_0x22:
	__CPWRN 20,21,3
	BRLO PC+2
	RJMP _0x24
; 0000 00E6 {
; 0000 00E7 c = keypad();
	RCALL SUBOPT_0x5
; 0000 00E8 
; 0000 00E9 if (c == '*' || (c == '#' && three_digit == 0))
	BREQ _0x26
	LDI  R30,LOW(35)
	CP   R30,R5
	BRNE _0x27
	CLR  R0
	CP   R0,R20
	CPC  R0,R21
	BREQ _0x26
_0x27:
	RJMP _0x25
_0x26:
; 0000 00EA {
; 0000 00EB error(1, "");
	RCALL SUBOPT_0x6
	__POINTW2MN _0x2A,0
	RCALL _error
; 0000 00EC }
; 0000 00ED else if (c == '#')  // use # to remove the last digit
	RJMP _0x2B
_0x25:
	LDI  R30,LOW(35)
	CP   R30,R5
	BRNE _0x2C
; 0000 00EE {
; 0000 00EF lcd_gotoxy(--col, 1);
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	SBIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _lcd_gotoxy
; 0000 00F0 lcd_printf("%c", '');
	RCALL SUBOPT_0xE
	__GETD1N 0x0
	RCALL SUBOPT_0xF
; 0000 00F1 three_digit--;
	__SUBWRN 20,21,1
; 0000 00F2 num/=10;              // remove the last digit
	MOVW R26,R16
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21U
	MOVW R16,R30
; 0000 00F3 if(!run_interrupt)   // check if we are in an interrupt
	TST  R10
	BRNE _0x2D
; 0000 00F4 curr_num = num; // save a copy of the number to use it after finishing the interrupt
	MOVW R8,R16
; 0000 00F5 }
_0x2D:
; 0000 00F6 else
	RJMP _0x2E
_0x2C:
; 0000 00F7 {
; 0000 00F8 three_digit++;
	__ADDWRN 20,21,1
; 0000 00F9 lcd_gotoxy(col++, 1);
	RCALL SUBOPT_0x10
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _lcd_gotoxy
; 0000 00FA if(enter_password==true)  // we are in the password mode
	LDI  R30,LOW(1)
	CP   R30,R11
	BRNE _0x2F
; 0000 00FB {
; 0000 00FC lcd_printf("*");
	__POINTW1FN _0x0,6
	RCALL SUBOPT_0x3
; 0000 00FD }
; 0000 00FE else
	RJMP _0x30
_0x2F:
; 0000 00FF {
; 0000 0100 lcd_printf("%c", c);
	RCALL SUBOPT_0xE
	MOV  R30,R5
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL SUBOPT_0xF
; 0000 0101 }
_0x30:
; 0000 0102 
; 0000 0103 curr_digit = c - '0';
	MOV  R30,R5
	LDI  R31,0
	SBIW R30,48
	MOVW R18,R30
; 0000 0104 num *= 10;
	__MULBNWRU 16,17,10
	MOVW R16,R30
; 0000 0105 num += curr_digit;       // add new digit to the number
	__ADDWRR 16,17,18,19
; 0000 0106 if(!run_interrupt)
	TST  R10
	BRNE _0x31
; 0000 0107 curr_num = num;
	MOVW R8,R16
; 0000 0108 }
_0x31:
_0x2E:
_0x2B:
; 0000 0109 }
	RJMP _0x22
_0x24:
; 0000 010A enter_password=false;    // disable password mode
	CLR  R11
; 0000 010B delay_ms(700);
	LDI  R26,LOW(700)
	LDI  R27,HIGH(700)
	RCALL _delay_ms
; 0000 010C lcd_clear();
	RCALL _lcd_clear
; 0000 010D return num;
	MOVW R30,R16
	RJMP _0x2080009
; 0000 010E }
; .FEND

	.DSEG
_0x2A:
	.BYTE 0x1
;unsigned char keypad()
; 0000 0111 {

	.CSEG
_keypad:
; .FSTART _keypad
; 0000 0112 while (1)
_0x32:
; 0000 0113 {
; 0000 0114 PORTC.0 = 0; PORTC.1 = 1; PORTC.2 = 1;
	CBI  0x15,0
	SBI  0x15,1
	SBI  0x15,2
; 0000 0115 //Only C1 is activated    (first column)
; 0000 0116 switch (PINC)
	IN   R30,0x13
; 0000 0117 {
; 0000 0118 case 0b11110110:       // first row is activated (be set with 0)  (col:1 , row 1)
	CPI  R30,LOW(0xF6)
	BRNE _0x3E
; 0000 0119 while (PINC.3 == 0);
_0x3F:
	SBIS 0x13,3
	RJMP _0x3F
; 0000 011A return '1';
	LDI  R30,LOW(49)
	RET
; 0000 011B break;
	RJMP _0x3D
; 0000 011C 
; 0000 011D case 0b11101110:       // second row is activated (be set with 0)  (col:1 , row 2)
_0x3E:
	CPI  R30,LOW(0xEE)
	BRNE _0x42
; 0000 011E while (PINC.4 == 0);
_0x43:
	SBIS 0x13,4
	RJMP _0x43
; 0000 011F return '4';
	LDI  R30,LOW(52)
	RET
; 0000 0120 break;
	RJMP _0x3D
; 0000 0121 
; 0000 0122 case 0b11011110:       // third row is activated (be set with 0)   (col:1 , row 3)
_0x42:
	CPI  R30,LOW(0xDE)
	BRNE _0x46
; 0000 0123 while (PINC.5 == 0);
_0x47:
	SBIS 0x13,5
	RJMP _0x47
; 0000 0124 return '7';
	LDI  R30,LOW(55)
	RET
; 0000 0125 break;
	RJMP _0x3D
; 0000 0126 
; 0000 0127 case 0b10111110:
_0x46:
	CPI  R30,LOW(0xBE)
	BRNE _0x3D
; 0000 0128 while (PINC.6 == 0);
_0x4B:
	SBIS 0x13,6
	RJMP _0x4B
; 0000 0129 return '*';
	LDI  R30,LOW(42)
	RET
; 0000 012A break;
; 0000 012B 
; 0000 012C }
_0x3D:
; 0000 012D 
; 0000 012E 
; 0000 012F PORTC.0 = 1; PORTC.1 = 0; PORTC.2 = 1;
	SBI  0x15,0
	CBI  0x15,1
	SBI  0x15,2
; 0000 0130 //Only C2 is activated       (second column)
; 0000 0131 switch (PINC)
	IN   R30,0x13
; 0000 0132 {
; 0000 0133 case 0b11110101:
	CPI  R30,LOW(0xF5)
	BRNE _0x57
; 0000 0134 while (PINC.3 == 0);
_0x58:
	SBIS 0x13,3
	RJMP _0x58
; 0000 0135 return '2';
	LDI  R30,LOW(50)
	RET
; 0000 0136 break;
	RJMP _0x56
; 0000 0137 
; 0000 0138 case 0b11101101:
_0x57:
	CPI  R30,LOW(0xED)
	BRNE _0x5B
; 0000 0139 while (PINC.4 == 0);
_0x5C:
	SBIS 0x13,4
	RJMP _0x5C
; 0000 013A return '5';
	LDI  R30,LOW(53)
	RET
; 0000 013B break;
	RJMP _0x56
; 0000 013C 
; 0000 013D case 0b11011101:
_0x5B:
	CPI  R30,LOW(0xDD)
	BRNE _0x5F
; 0000 013E while (PINC.5 == 0);
_0x60:
	SBIS 0x13,5
	RJMP _0x60
; 0000 013F return '8';
	LDI  R30,LOW(56)
	RET
; 0000 0140 break;
	RJMP _0x56
; 0000 0141 
; 0000 0142 case 0b10111101:
_0x5F:
	CPI  R30,LOW(0xBD)
	BRNE _0x56
; 0000 0143 while (PINC.6 == 0);
_0x64:
	SBIS 0x13,6
	RJMP _0x64
; 0000 0144 return '0';
	LDI  R30,LOW(48)
	RET
; 0000 0145 break;
; 0000 0146 
; 0000 0147 }
_0x56:
; 0000 0148 
; 0000 0149 
; 0000 014A PORTC.0 = 1; PORTC.1 = 1; PORTC.2 = 0;
	SBI  0x15,0
	SBI  0x15,1
	CBI  0x15,2
; 0000 014B //Only C3 is activated       (third column)
; 0000 014C switch (PINC)
	IN   R30,0x13
; 0000 014D {
; 0000 014E case 0b11110011:
	CPI  R30,LOW(0xF3)
	BRNE _0x70
; 0000 014F while (PINC.3 == 0);
_0x71:
	SBIS 0x13,3
	RJMP _0x71
; 0000 0150 return '3';
	LDI  R30,LOW(51)
	RET
; 0000 0151 break;
	RJMP _0x6F
; 0000 0152 
; 0000 0153 case 0b11101011:
_0x70:
	CPI  R30,LOW(0xEB)
	BRNE _0x74
; 0000 0154 while (PINC.4 == 0);
_0x75:
	SBIS 0x13,4
	RJMP _0x75
; 0000 0155 return '6';
	LDI  R30,LOW(54)
	RET
; 0000 0156 break;
	RJMP _0x6F
; 0000 0157 
; 0000 0158 case 0b11011011:
_0x74:
	CPI  R30,LOW(0xDB)
	BRNE _0x78
; 0000 0159 while (PINC.5 == 0);
_0x79:
	SBIS 0x13,5
	RJMP _0x79
; 0000 015A return '9';
	LDI  R30,LOW(57)
	RET
; 0000 015B break;
	RJMP _0x6F
; 0000 015C 
; 0000 015D case 0b10111011:
_0x78:
	CPI  R30,LOW(0xBB)
	BRNE _0x6F
; 0000 015E while (PINC.6 == 0);
_0x7D:
	SBIS 0x13,6
	RJMP _0x7D
; 0000 015F return '#';
	LDI  R30,LOW(35)
	RET
; 0000 0160 break;
; 0000 0161 
; 0000 0162 }
_0x6F:
; 0000 0163 
; 0000 0164 }
	RJMP _0x32
; 0000 0165 }
; .FEND
;_Bool match_ID_PC(unsigned int id, unsigned int entered_passward)
; 0000 0169 {
_match_ID_PC:
; .FSTART _match_ID_PC
; 0000 016A unsigned int id_passward = 0;
; 0000 016B id_passward = get_passward(id);
	RCALL SUBOPT_0x11
;	id -> R20,R21
;	entered_passward -> R18,R19
;	id_passward -> R16,R17
	RCALL _get_passward
	MOVW R16,R30
; 0000 016C return(id_passward == entered_passward);
	MOVW R30,R18
	MOVW R26,R16
	RCALL __EQW12
	RJMP _0x2080009
; 0000 016D }
; .FEND
;void set_passcode()
; 0000 0171 {
_set_passcode:
; .FSTART _set_passcode
; 0000 0172 unsigned int old_password = 0, id = 0;
; 0000 0173 
; 0000 0174 lcd_clear();
	RCALL __SAVELOCR4
;	old_password -> R16,R17
;	id -> R18,R19
	RCALL SUBOPT_0x12
	RCALL _lcd_clear
; 0000 0175 lcd_puts("Enter your ID");
	__POINTW2MN _0x80,0
	RCALL _lcd_puts
; 0000 0176 lcd_gotoxy(0, 1);
	RCALL SUBOPT_0x8
; 0000 0177 id = read_lcd();
	RCALL SUBOPT_0x9
; 0000 0178 if (exist(id))
	BREQ _0x81
; 0000 0179 {   enter_password=true;
	LDI  R30,LOW(1)
	MOV  R11,R30
; 0000 017A lcd_puts("Enter old PC :");
	__POINTW2MN _0x80,14
	RCALL _lcd_puts
; 0000 017B lcd_gotoxy(0, 1);
	RCALL SUBOPT_0x8
; 0000 017C old_password = read_lcd();
	RCALL SUBOPT_0xB
; 0000 017D if (match_ID_PC(id, old_password))
	BREQ _0x82
; 0000 017E {
; 0000 017F lcd_clear();
	RCALL _lcd_clear
; 0000 0180 enter_password=true;
	LDI  R30,LOW(1)
	MOV  R11,R30
; 0000 0181 lcd_puts("Enter new PC :");
	__POINTW2MN _0x80,29
	RCALL _lcd_puts
; 0000 0182 lcd_gotoxy(0, 1);
	RCALL SUBOPT_0x8
; 0000 0183 update_password(id);
	MOVW R26,R18
	RCALL _update_password
; 0000 0184 }
; 0000 0185 else
	RJMP _0x83
_0x82:
; 0000 0186 {
; 0000 0187 lcd_clear();
	RCALL _lcd_clear
; 0000 0188 error(2, "Contact Admin");
	RCALL SUBOPT_0xD
	__POINTW2MN _0x80,44
	RCALL _error
; 0000 0189 }
_0x83:
; 0000 018A }
; 0000 018B else
	RJMP _0x84
_0x81:
; 0000 018C {
; 0000 018D lcd_clear();
	RCALL _lcd_clear
; 0000 018E error(2, "Contact Admin");
	RCALL SUBOPT_0xD
	__POINTW2MN _0x80,58
	RCALL _error
; 0000 018F }
_0x84:
; 0000 0190 
; 0000 0191 
; 0000 0192 }
	JMP  _0x2080003
; .FEND

	.DSEG
_0x80:
	.BYTE 0x48
;void update_password(unsigned int id)
; 0000 0196 {

	.CSEG
_update_password:
; .FSTART _update_password
; 0000 0197 unsigned int new_passward = 0, reenter_new_password = 0, idx = 0;
; 0000 0198 
; 0000 0199 new_passward = read_lcd();
	ST   -Y,R27
	ST   -Y,R26
	RCALL SUBOPT_0x7
;	id -> Y+6
;	new_passward -> R16,R17
;	reenter_new_password -> R18,R19
;	idx -> R20,R21
	__GETWRN 20,21,0
	RCALL _read_lcd
	MOVW R16,R30
; 0000 019A lcd_clear();
	RCALL SUBOPT_0xA
; 0000 019B enter_password=true;
; 0000 019C curr_num =-1;
; 0000 019D lcd_puts("Re-enter new PC");
	__POINTW2MN _0x85,0
	RCALL _lcd_puts
; 0000 019E lcd_gotoxy(0, 1);
	RCALL SUBOPT_0x8
; 0000 019F reenter_new_password = read_lcd();
	RCALL _read_lcd
	MOVW R18,R30
; 0000 01A0 if (new_passward != reenter_new_password) error(2, "Contact Admin");
	__CPWRR 18,19,16,17
	BREQ _0x86
	RCALL SUBOPT_0xD
	__POINTW2MN _0x85,16
	RCALL _error
; 0000 01A1 else
	RJMP _0x87
_0x86:
; 0000 01A2 {
; 0000 01A3 idx = get_id_location(id);
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RCALL _get_id_location
	MOVW R20,R30
; 0000 01A4 idx += 2;   // skip id address lines
	__ADDWRN 20,21,2
; 0000 01A5 
; 0000 01A6 // remove old passsward
; 0000 01A7 EE_Write(idx++, '0'); EE_Write(idx++, '0');
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x13
; 0000 01A8 
; 0000 01A9 //add the new passward
; 0000 01AA idx -= 2;                              // return to the number of the first address that the passward can be stored in
	__SUBWRN 20,21,2
; 0000 01AB 
; 0000 01AC store_number(new_passward, idx, 1);  // store the new password
	ST   -Y,R17
	ST   -Y,R16
	ST   -Y,R21
	ST   -Y,R20
	LDI  R26,LOW(1)
	RCALL _store_number
; 0000 01AD 
; 0000 01AE lcd_clear();
	RCALL _lcd_clear
; 0000 01AF lcd_puts("New PC stored");
	__POINTW2MN _0x85,30
	RCALL _lcd_puts
; 0000 01B0 }
_0x87:
; 0000 01B1 }
	RJMP _0x2080009
; .FEND

	.DSEG
_0x85:
	.BYTE 0x2C
;unsigned int get_passward(unsigned int id)
; 0000 01B5 {

	.CSEG
_get_passward:
; .FSTART _get_passward
; 0000 01B6 unsigned int idx = 0, number = 0;
; 0000 01B7 idx = get_id_location(id);
	RCALL __SAVELOCR6
	MOVW R20,R26
;	id -> R20,R21
;	idx -> R16,R17
;	number -> R18,R19
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0x14
; 0000 01B8 
; 0000 01B9 idx += 2;              // skip id address lines
; 0000 01BA 
; 0000 01BB // get the password
; 0000 01BC number = get_number(idx);
	MOVW R26,R16
	RCALL _get_number
	MOVW R18,R30
; 0000 01BD return number;
	RCALL __LOADLOCR6
	RJMP _0x2080005
; 0000 01BE 
; 0000 01BF }
; .FEND
;void admin_update_password(unsigned int id, unsigned int new_passward)
; 0000 01C3 {
_admin_update_password:
; .FSTART _admin_update_password
; 0000 01C4 unsigned int idx = 0;
; 0000 01C5 idx = get_id_location(id);
	RCALL SUBOPT_0x11
;	id -> R20,R21
;	new_passward -> R18,R19
;	idx -> R16,R17
	RCALL _get_id_location
	MOVW R16,R30
; 0000 01C6 idx += 2;   // skip id address lines
	__ADDWRN 16,17,2
; 0000 01C7 
; 0000 01C8 // remove old passsward
; 0000 01C9 EE_Write(idx++, '0'); EE_Write(idx++, '0');
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x15
; 0000 01CA 
; 0000 01CB //add the new passward
; 0000 01CC idx -= 2;                               // return to the number of the first address that the passward can be stored in
	__SUBWRN 16,17,2
; 0000 01CD store_number(new_passward, idx, 1);   // store the new password
	RCALL SUBOPT_0x16
; 0000 01CE 
; 0000 01CF lcd_clear();
	RCALL _lcd_clear
; 0000 01D0 lcd_puts("PC is stored");
	__POINTW2MN _0x88,0
	RCALL _lcd_puts
; 0000 01D1 }
_0x2080009:
	RCALL __LOADLOCR6
	ADIW R28,8
	RET
; .FEND

	.DSEG
_0x88:
	.BYTE 0xD
;char* get_name(unsigned int id)
; 0000 01D5 {

	.CSEG
_get_name:
; .FSTART _get_name
; 0000 01D6 unsigned int idx = 0;
; 0000 01D7 char* name;
; 0000 01D8 
; 0000 01D9 idx = get_id_location(id);
	RCALL SUBOPT_0x17
;	id -> R20,R21
;	idx -> R16,R17
;	*name -> R18,R19
	RCALL SUBOPT_0x14
; 0000 01DA idx += 2; // skip the id address lines
; 0000 01DB idx += 2; // skip the password address lines
	__ADDWRN 16,17,2
; 0000 01DC 
; 0000 01DD // get the name
; 0000 01DE name = get_name_fromEEPROM(idx);
	MOVW R26,R16
	RCALL _get_name_fromEEPROM
	MOVW R18,R30
; 0000 01DF 
; 0000 01E0 
; 0000 01E1 return name;
	RCALL __LOADLOCR6
	RJMP _0x2080005
; 0000 01E2 
; 0000 01E3 }
; .FEND
;_Bool exist(unsigned int id)
; 0000 01E7 {
_exist:
; .FSTART _exist
; 0000 01E8 if (get_id_location(id) == -1) return 0;
	ST   -Y,R17
	ST   -Y,R16
	MOVW R16,R26
;	id -> R16,R17
	RCALL _get_id_location
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x89
	LDI  R30,LOW(0)
	RJMP _0x2080007
; 0000 01E9 return 1;
_0x89:
	LDI  R30,LOW(1)
	RJMP _0x2080007
; 0000 01EA }
; .FEND
;int get_id_location(unsigned int id)
; 0000 01EE {
_get_id_location:
; .FSTART _get_id_location
; 0000 01EF unsigned int i = 0, number = 0, flag = 0, length;
; 0000 01F0 unsigned char ch;
; 0000 01F1 for (i = 0; i < curr_location; i++)
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,3
	RCALL SUBOPT_0x7
;	id -> Y+9
;	i -> R16,R17
;	number -> R18,R19
;	flag -> R20,R21
;	length -> Y+7
;	ch -> Y+6
	__GETWRN 20,21,0
	__GETWRN 16,17,0
_0x8B:
	__CPWRR 16,17,6,7
	BRSH _0x8C
; 0000 01F2 {
; 0000 01F3 ch = EE_Read(i);
	MOVW R26,R16
	RCALL _EE_Read
	STD  Y+6,R30
; 0000 01F4 flag = check_flags(ch);
	LDD  R26,Y+6
	RCALL _check_flags
	MOVW R20,R30
; 0000 01F5 if (flag == 0)  // ID
	MOV  R0,R20
	OR   R0,R21
	BRNE _0x8D
; 0000 01F6 {
; 0000 01F7 number = get_number(i);
	MOVW R26,R16
	RCALL _get_number
	MOVW R18,R30
; 0000 01F8 if (number == id) return i;
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	CP   R30,R18
	CPC  R31,R19
	BRNE _0x8E
	MOVW R30,R16
	RJMP _0x2080008
; 0000 01F9 i++;    // skip the second byte
_0x8E:
	__ADDWRN 16,17,1
; 0000 01FA 
; 0000 01FB }
; 0000 01FC else if (flag == 1) // PC
	RJMP _0x8F
_0x8D:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R20
	CPC  R31,R21
	BRNE _0x90
; 0000 01FD {
; 0000 01FE i++; // skip PC bytes
	__ADDWRN 16,17,1
; 0000 01FF }
; 0000 0200 else if (flag == 2)
	RJMP _0x91
_0x90:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R20
	CPC  R31,R21
	BRNE _0x92
; 0000 0201 {
; 0000 0202 length = get_nameLength(ch);
	LDD  R26,Y+6
	RCALL _get_nameLength
	STD  Y+7,R30
	STD  Y+7+1,R31
; 0000 0203 i += length;   // skip the name
	__ADDWRR 16,17,30,31
; 0000 0204 }
; 0000 0205 }
_0x92:
_0x91:
_0x8F:
	__ADDWRN 16,17,1
	RJMP _0x8B
_0x8C:
; 0000 0206 return -1;
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
_0x2080008:
	RCALL __LOADLOCR6
	ADIW R28,11
	RET
; 0000 0207 }
; .FEND
;unsigned int check_flags(unsigned char curr_char) {
; 0000 020A unsigned int check_flags(unsigned char curr_char) {
_check_flags:
; .FSTART _check_flags
; 0000 020B // Get the values of the last two bits (6,7)
; 0000 020C int bit6 = (curr_char >> 6) & 1;
; 0000 020D int bit7 = (curr_char >> 7) & 1;
; 0000 020E 
; 0000 020F if (bit7 == 1 && bit6 == 0) {
	ST   -Y,R26
	RCALL __SAVELOCR4
;	curr_char -> Y+4
;	bit6 -> R16,R17
;	bit7 -> R18,R19
	LDD  R26,Y+4
	LDI  R27,0
	LDI  R30,LOW(6)
	RCALL __ASRW12
	ANDI R30,LOW(0x1)
	ANDI R31,HIGH(0x1)
	MOVW R16,R30
	LDD  R26,Y+4
	LDI  R27,0
	LDI  R30,LOW(7)
	RCALL __ASRW12
	ANDI R30,LOW(0x1)
	ANDI R31,HIGH(0x1)
	MOVW R18,R30
	RCALL SUBOPT_0x18
	BRNE _0x94
	CLR  R0
	CP   R0,R16
	CPC  R0,R17
	BREQ _0x95
_0x94:
	RJMP _0x93
_0x95:
; 0000 0210 return 1;    // Check PC (10)
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	JMP  _0x2080001
; 0000 0211 }
; 0000 0212 else if (bit7 == 0 && bit6 == 1) {
_0x93:
	CLR  R0
	CP   R0,R18
	CPC  R0,R19
	BRNE _0x98
	RCALL SUBOPT_0x19
	BREQ _0x99
_0x98:
	RJMP _0x97
_0x99:
; 0000 0213 return 0;   // Check ID (01)
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	JMP  _0x2080001
; 0000 0214 }
; 0000 0215 else if (bit7 == 1 && bit6 == 1) {
_0x97:
	RCALL SUBOPT_0x18
	BRNE _0x9C
	RCALL SUBOPT_0x19
	BREQ _0x9D
_0x9C:
	RJMP _0x9B
_0x9D:
; 0000 0216 return 2;   // Check name (11)
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	JMP  _0x2080001
; 0000 0217 }
; 0000 0218 
; 0000 0219 // error
; 0000 021A return 3;
_0x9B:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	JMP  _0x2080001
; 0000 021B }
; .FEND
;unsigned int get_nameLength(unsigned char ch)
; 0000 021F {
_get_nameLength:
; .FSTART _get_nameLength
; 0000 0220 unsigned length = 0;
; 0000 0221 length = ch;
	RCALL __SAVELOCR4
	MOV  R19,R26
;	ch -> R19
;	length -> R16,R17
	__GETWRN 16,17,0
	MOV  R16,R19
	CLR  R17
; 0000 0222 // disable flag
; 0000 0223 length = SetBit0(length, 6);
	ST   -Y,R17
	ST   -Y,R16
	LDI  R26,LOW(6)
	LDI  R27,0
	RCALL _SetBit0
	MOVW R16,R30
; 0000 0224 length = SetBit0(length, 7);
	ST   -Y,R17
	ST   -Y,R16
	LDI  R26,LOW(7)
	LDI  R27,0
	RCALL _SetBit0
	MOVW R16,R30
; 0000 0225 return length;
	JMP  _0x2080003
; 0000 0226 }
; .FEND
;void admin_interaction()
; 0000 022A {
_admin_interaction:
; .FSTART _admin_interaction
; 0000 022B unsigned int AdminPc = 0, StudentID = 0, StudentPC = 0;
; 0000 022C 
; 0000 022D lcd_clear();
	RCALL SUBOPT_0x7
;	AdminPc -> R16,R17
;	StudentID -> R18,R19
;	StudentPC -> R20,R21
	__GETWRN 20,21,0
	RCALL _lcd_clear
; 0000 022E enter_password = true;
	LDI  R30,LOW(1)
	MOV  R11,R30
; 0000 022F lcd_printf("Enter Admin PC");
	__POINTW1FN _0x0,179
	RCALL SUBOPT_0x3
; 0000 0230 lcd_gotoxy(0, 1);
	RCALL SUBOPT_0x8
; 0000 0231 AdminPc = read_lcd();
	RCALL _read_lcd
	MOVW R16,R30
; 0000 0232 if (match_ID_PC(111, AdminPc))
	LDI  R30,LOW(111)
	LDI  R31,HIGH(111)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R16
	RCALL _match_ID_PC
	CPI  R30,0
	BREQ _0x9E
; 0000 0233 {
; 0000 0234 lcd_clear();
	RCALL _lcd_clear
; 0000 0235 lcd_puts("Enter Student ID");
	__POINTW2MN _0x9F,0
	RCALL _lcd_puts
; 0000 0236 lcd_gotoxy(0, 1);
	RCALL SUBOPT_0x8
; 0000 0237 StudentID = read_lcd();
	RCALL SUBOPT_0x9
; 0000 0238 if (exist(StudentID))
	BREQ _0xA0
; 0000 0239 {
; 0000 023A lcd_clear();
	RCALL _lcd_clear
; 0000 023B enter_password = true;
	LDI  R30,LOW(1)
	MOV  R11,R30
; 0000 023C lcd_puts("Enter new PC");
	__POINTW2MN _0x9F,17
	RCALL _lcd_puts
; 0000 023D lcd_gotoxy(0, 1);
	RCALL SUBOPT_0x8
; 0000 023E StudentPC = read_lcd();
	RCALL _read_lcd
	MOVW R20,R30
; 0000 023F admin_update_password(StudentID, StudentPC);
	ST   -Y,R19
	ST   -Y,R18
	MOVW R26,R20
	RCALL _admin_update_password
; 0000 0240 }
; 0000 0241 else
	RJMP _0xA1
_0xA0:
; 0000 0242 {
; 0000 0243 lcd_clear();
	RCALL _lcd_clear
; 0000 0244 error(1, "Contact Admin");
	RCALL SUBOPT_0x6
	__POINTW2MN _0x9F,30
	RCALL _error
; 0000 0245 }
_0xA1:
; 0000 0246 }
; 0000 0247 else
	RJMP _0xA2
_0x9E:
; 0000 0248 {
; 0000 0249 lcd_clear();
	RCALL _lcd_clear
; 0000 024A error(2, "Contact Admin");
	RCALL SUBOPT_0xD
	__POINTW2MN _0x9F,44
	RCALL _error
; 0000 024B }
_0xA2:
; 0000 024C 
; 0000 024D }
	RCALL __LOADLOCR6
	RJMP _0x2080005
; .FEND

	.DSEG
_0x9F:
	.BYTE 0x3A
;void EE_Write(unsigned int address, unsigned char data)
; 0000 0254 {

	.CSEG
_EE_Write:
; .FSTART _EE_Write
; 0000 0255 while (EECR.1 == 1);    //Wait till EEPROM is ready
	RCALL __SAVELOCR4
	MOV  R17,R26
	__GETWRS 18,19,4
;	address -> R18,R19
;	data -> R17
_0xA3:
	SBIC 0x1C,1
	RJMP _0xA3
; 0000 0256 EEAR = address;        //Prepare the address you want to read from
	__OUTWR 18,19,30
; 0000 0257 EEDR = data;           //Prepare the data you want to write in the address above
	OUT  0x1D,R17
; 0000 0258 EECR.2 = 1;            //Master write enable
	SBI  0x1C,2
; 0000 0259 EECR.1 = 1;            //Write Enable
	SBI  0x1C,1
; 0000 025A }
	RJMP _0x2080004
; .FEND
;unsigned char EE_Read(unsigned int address)
; 0000 025E {
_EE_Read:
; .FSTART _EE_Read
; 0000 025F while (EECR.1 == 1);    //Wait till EEPROM is ready
	ST   -Y,R17
	ST   -Y,R16
	MOVW R16,R26
;	address -> R16,R17
_0xAA:
	SBIC 0x1C,1
	RJMP _0xAA
; 0000 0260 EEAR = address;        //Prepare the address you want to read from
	__OUTWR 16,17,30
; 0000 0261 
; 0000 0262 EECR.0 = 1;            //Execute read command
	SBI  0x1C,0
; 0000 0263 
; 0000 0264 return EEDR;
	IN   R30,0x1D
_0x2080007:
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0000 0265 
; 0000 0266 }
; .FEND
;unsigned int store(char name[], unsigned int id, unsigned int password, unsigned int location)
; 0000 026A {
_store:
; .FSTART _store
; 0000 026B 
; 0000 026C // Store Id
; 0000 026D location = store_number(id, location, 0);
	RCALL __SAVELOCR6
	MOVW R16,R26
	__GETWRS 18,19,6
	__GETWRS 20,21,8
;	name -> Y+10
;	id -> R20,R21
;	password -> R18,R19
;	location -> R16,R17
	ST   -Y,R21
	ST   -Y,R20
	ST   -Y,R17
	ST   -Y,R16
	LDI  R26,LOW(0)
	RCALL _store_number
	MOVW R16,R30
; 0000 026E 
; 0000 026F // Store Password
; 0000 0270 location = store_number(password, location, 1);
	RCALL SUBOPT_0x16
	MOVW R16,R30
; 0000 0271 
; 0000 0272 // Store Name
; 0000 0273 location = store_name(name, location);
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R16
	RCALL _store_name
	MOVW R16,R30
; 0000 0274 
; 0000 0275 return location;
	RCALL __LOADLOCR6
	ADIW R28,12
	RET
; 0000 0276 }
; .FEND
;unsigned int store_number(unsigned int number, unsigned int location, _Bool ID_or_PC)
; 0000 027A {
_store_number:
; .FSTART _store_number
; 0000 027B unsigned char idByte1, idByte2;
; 0000 027C //get the last two bits of the number (8,9) .. and shift them to be bit (0,1) at the first byte
; 0000 027D idByte1 = ((number & 0b001100000000) >> 8);
	RCALL __SAVELOCR6
	MOV  R19,R26
	__GETWRS 20,21,6
;	number -> Y+8
;	location -> R20,R21
;	ID_or_PC -> R19
;	idByte1 -> R17
;	idByte2 -> R16
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ANDI R30,LOW(0x300)
	ANDI R31,HIGH(0x300)
	MOV  R30,R31
	LDI  R31,0
	MOV  R17,R30
; 0000 027E 
; 0000 027F if (ID_or_PC) idByte1 = 0b10000000 | idByte1;     // enable PC flag(10)
	CPI  R19,0
	BREQ _0xAF
	ORI  R17,LOW(128)
; 0000 0280 else idByte1 = 0b01000000 | idByte1;             // enable id flag (01)
	RJMP _0xB0
_0xAF:
	ORI  R17,LOW(64)
; 0000 0281 
; 0000 0282 
; 0000 0283 // get the first 8 bits(0 > 7) from id to store them at byte2
; 0000 0284 idByte2 = number & 0b11111111;
_0xB0:
	LDD  R30,Y+8
	MOV  R16,R30
; 0000 0285 
; 0000 0286 //store the number in EEPROM
; 0000 0287 EE_Write(location++, idByte1);
	RCALL SUBOPT_0x1A
	MOV  R26,R17
	RCALL _EE_Write
; 0000 0288 EE_Write(location++, idByte2);
	RCALL SUBOPT_0x1A
	MOV  R26,R16
	RCALL _EE_Write
; 0000 0289 
; 0000 028A // we use two address lines of the EEPROM
; 0000 028B return location;
	MOVW R30,R20
	RJMP _0x2080006
; 0000 028C }
; .FEND
;unsigned int store_name(char name[], unsigned int location)
; 0000 0290 {
_store_name:
; .FSTART _store_name
; 0000 0291 unsigned int length = 0, i = 0;
; 0000 0292 unsigned char name_byte;
; 0000 0293 
; 0000 0294 // get the length of the name
; 0000 0295 length = 0;
	ST   -Y,R27
	ST   -Y,R26
	RCALL SUBOPT_0x7
;	name -> Y+8
;	location -> Y+6
;	length -> R16,R17
;	i -> R18,R19
;	name_byte -> R21
	__GETWRN 16,17,0
; 0000 0296 for (length = 0; name[length] != '\0'; length++) {}
	__GETWRN 16,17,0
_0xB2:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADD  R26,R16
	ADC  R27,R17
	LD   R30,X
	CPI  R30,0
	BREQ _0xB3
	__ADDWRN 16,17,1
	RJMP _0xB2
_0xB3:
; 0000 0297 
; 0000 0298 // prepare the byte that indicates the name info
; 0000 0299 name_byte = length;                     // use the first 6 bits of tell use the length of the name
	MOV  R21,R16
; 0000 029A 
; 0000 029B name_byte = 0b11000000 | name_byte;      // enable name flag (11)
	ORI  R21,LOW(192)
; 0000 029C 
; 0000 029D //store the name_byte before the actual name in EEPROM
; 0000 029E EE_Write(location++, name_byte);
	RCALL SUBOPT_0x10
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R21
	RCALL _EE_Write
; 0000 029F 
; 0000 02A0 // store the name in EEPROM
; 0000 02A1 i = 0;
	RCALL SUBOPT_0x0
; 0000 02A2 for (i = 0; i < length; i++) EE_Write(location++, name[i]);
_0xB5:
	__CPWRR 18,19,16,17
	BRSH _0xB6
	RCALL SUBOPT_0x10
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	ADD  R26,R18
	ADC  R27,R19
	LD   R26,X
	RCALL _EE_Write
	__ADDWRN 18,19,1
	RJMP _0xB5
_0xB6:
; 0000 02A4 return location;
	LDD  R30,Y+6
	LDD  R31,Y+6+1
_0x2080006:
	RCALL __LOADLOCR6
	ADIW R28,10
	RET
; 0000 02A5 }
; .FEND
;unsigned get_number(unsigned int location)
; 0000 02A9 {
_get_number:
; .FSTART _get_number
; 0000 02AA unsigned int number = 0, first_byte;
; 0000 02AB 
; 0000 02AC // get the second byte value first
; 0000 02AD number = EE_Read(location + 1);
	RCALL SUBOPT_0x17
;	location -> R20,R21
;	number -> R16,R17
;	first_byte -> R18,R19
	MOVW R26,R20
	ADIW R26,1
	RCALL _EE_Read
	MOV  R16,R30
	CLR  R17
; 0000 02AE 
; 0000 02AF // disable the last two bits of the first byte  (flags)
; 0000 02B0 first_byte = EE_Read(location);
	MOVW R26,R20
	RCALL SUBOPT_0x1B
; 0000 02B1 first_byte = SetBit0(first_byte, 6);
; 0000 02B2 first_byte = SetBit0(first_byte, 7);
; 0000 02B3 
; 0000 02B4 
; 0000 02B5 //make the first two bits of the second byte equal to bits number (8,9) of number
; 0000 02B6 if (GetBit(first_byte, 0)) number = SetBit1(number, 8);
	ST   -Y,R19
	ST   -Y,R18
	LDI  R26,LOW(0)
	LDI  R27,0
	RCALL _GetBit
	SBIW R30,0
	BREQ _0xB7
	ST   -Y,R17
	ST   -Y,R16
	LDI  R26,LOW(8)
	LDI  R27,0
	RCALL _SetBit1
	MOVW R16,R30
; 0000 02B7 if (GetBit(first_byte, 1)) number = SetBit1(number, 9);
_0xB7:
	ST   -Y,R19
	ST   -Y,R18
	LDI  R26,LOW(1)
	LDI  R27,0
	RCALL _GetBit
	SBIW R30,0
	BREQ _0xB8
	ST   -Y,R17
	ST   -Y,R16
	LDI  R26,LOW(9)
	LDI  R27,0
	RCALL _SetBit1
	MOVW R16,R30
; 0000 02B8 
; 0000 02B9 
; 0000 02BA return number;
_0xB8:
	MOVW R30,R16
	RCALL __LOADLOCR6
	RJMP _0x2080005
; 0000 02BB }
; .FEND
;char* get_name_fromEEPROM(unsigned int location)
; 0000 02BF {
_get_name_fromEEPROM:
; .FSTART _get_name_fromEEPROM
; 0000 02C0 unsigned int index = 0, length = 0;
; 0000 02C1 static char personName[17 + 1];
; 0000 02C2 
; 0000 02C3 // get the length of the name and disable the 6,7 bits (flags)
; 0000 02C4 length = EE_Read(location++);
	RCALL __SAVELOCR6
	MOVW R20,R26
;	location -> R20,R21
;	index -> R16,R17
;	length -> R18,R19
	RCALL SUBOPT_0x12
	MOVW R26,R20
	__ADDWRN 20,21,1
	RCALL SUBOPT_0x1B
; 0000 02C5 length = SetBit0(length, 6);
; 0000 02C6 length = SetBit0(length, 7);
; 0000 02C7 
; 0000 02C8 
; 0000 02C9 // get the name from EEPROM
; 0000 02CA while (length--)
_0xB9:
	MOVW R30,R18
	__SUBWRN 18,19,1
	SBIW R30,0
	BREQ _0xBB
; 0000 02CB {
; 0000 02CC personName[index++] = EE_Read(location++);
	MOVW R30,R16
	__ADDWRN 16,17,1
	SUBI R30,LOW(-_personName_S0000018000)
	SBCI R31,HIGH(-_personName_S0000018000)
	PUSH R31
	PUSH R30
	MOVW R26,R20
	__ADDWRN 20,21,1
	RCALL _EE_Read
	POP  R26
	POP  R27
	ST   X,R30
; 0000 02CD }
	RJMP _0xB9
_0xBB:
; 0000 02CE 
; 0000 02CF 
; 0000 02D0 return personName;
	LDI  R30,LOW(_personName_S0000018000)
	LDI  R31,HIGH(_personName_S0000018000)
	RCALL __LOADLOCR6
	RJMP _0x2080005
; 0000 02D1 }
; .FEND
;void error(int number_of_peeps, const char* message) {
; 0000 02D4 void error(int number_of_peeps, const char* message) {
_error:
; .FSTART _error
; 0000 02D5 while (number_of_peeps) {
	RCALL SUBOPT_0x1C
;	number_of_peeps -> R18,R19
;	*message -> R16,R17
_0xBC:
	MOV  R0,R18
	OR   R0,R19
	BREQ _0xBE
; 0000 02D6 int i;
; 0000 02D7 for (i = 0; i < 25; i++) {
	SBIW R28,2
;	i -> Y+0
	LDI  R30,LOW(0)
	STD  Y+0,R30
	STD  Y+0+1,R30
_0xC0:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,25
	BRGE _0xC1
; 0000 02D8 PORTD.5 = 1;
	SBI  0x12,5
; 0000 02D9 delay_ms(2);
	LDI  R26,LOW(2)
	LDI  R27,0
	RCALL _delay_ms
; 0000 02DA PORTD.5 = 0;
	CBI  0x12,5
; 0000 02DB delay_ms(2);
	LDI  R26,LOW(2)
	LDI  R27,0
	RCALL _delay_ms
; 0000 02DC }
	LD   R30,Y
	LDD  R31,Y+1
	ADIW R30,1
	ST   Y,R30
	STD  Y+1,R31
	RJMP _0xC0
_0xC1:
; 0000 02DD delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	RCALL _delay_ms
; 0000 02DE number_of_peeps--;
	__SUBWRN 18,19,1
; 0000 02DF }
	ADIW R28,2
	RJMP _0xBC
_0xBE:
; 0000 02E0 if (strlen(message) != 0)
	MOVW R26,R16
	RCALL _strlen
	SBIW R30,0
	BREQ _0xC6
; 0000 02E1 {
; 0000 02E2 lcd_clear();
	RCALL _lcd_clear
; 0000 02E3 lcd_printf("%s", message);
	RCALL SUBOPT_0x1D
	MOVW R30,R16
	RCALL SUBOPT_0xC
; 0000 02E4 }
; 0000 02E5 
; 0000 02E6 }
_0xC6:
	RJMP _0x2080004
; .FEND
;void open_door()
; 0000 02EC {
_open_door:
; .FSTART _open_door
; 0000 02ED PORTB.0 = 1;
	SBI  0x18,0
; 0000 02EE PORTB.1 = 0;
	CBI  0x18,1
; 0000 02EF delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RCALL _delay_ms
; 0000 02F0 PORTB.1 = 1;
	SBI  0x18,1
; 0000 02F1 }
	RET
; .FEND
;void close_door()
; 0000 02F5 {
_close_door:
; .FSTART _close_door
; 0000 02F6 PORTB.0 = 0;
	CBI  0x18,0
; 0000 02F7 PORTB.1 = 1;
	SBI  0x18,1
; 0000 02F8 delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RCALL _delay_ms
; 0000 02F9 PORTB.0 = 1;
	SBI  0x18,0
; 0000 02FA }
	RET
; .FEND
;unsigned int GetBit(unsigned int num, unsigned int idx) {
; 0000 02FE unsigned int GetBit(unsigned int num, unsigned int idx) {
_GetBit:
; .FSTART _GetBit
; 0000 02FF return (num >> idx) & 1;
	RCALL SUBOPT_0x1C
;	num -> R18,R19
;	idx -> R16,R17
	MOV  R30,R16
	MOVW R26,R18
	RCALL __LSRW12
	ANDI R30,LOW(0x1)
	ANDI R31,HIGH(0x1)
	RJMP _0x2080004
; 0000 0300 }
; .FEND
;unsigned int SetBit1(unsigned int num, unsigned int idx) {
; 0000 0302 unsigned int SetBit1(unsigned int num, unsigned int idx) {
_SetBit1:
; .FSTART _SetBit1
; 0000 0303 return num | (1 << idx);
	RCALL SUBOPT_0x1C
;	num -> R18,R19
;	idx -> R16,R17
	RCALL SUBOPT_0x1E
	OR   R30,R18
	OR   R31,R19
	RJMP _0x2080004
; 0000 0304 }
; .FEND
;unsigned int SetBit0(unsigned num, unsigned int idx) {
; 0000 0306 unsigned int SetBit0(unsigned num, unsigned int idx) {
_SetBit0:
; .FSTART _SetBit0
; 0000 0307 return num & ~(1 << idx);
	RCALL SUBOPT_0x1C
;	num -> R18,R19
;	idx -> R16,R17
	RCALL SUBOPT_0x1E
	COM  R30
	COM  R31
	AND  R30,R18
	AND  R31,R19
_0x2080004:
	RCALL __LOADLOCR4
_0x2080005:
	ADIW R28,6
	RET
; 0000 0308 }
; .FEND
;void handle_interrupt(_Bool check_password)
; 0000 030D {
_handle_interrupt:
; .FSTART _handle_interrupt
; 0000 030E delay_ms(1000);
	ST   -Y,R17
	MOV  R17,R26
;	check_password -> R17
	RCALL SUBOPT_0x2
; 0000 030F lcd_clear();
; 0000 0310 lcd_printf("%s", curr_lcd);
	RCALL SUBOPT_0x1D
	LDI  R30,LOW(_curr_lcd)
	LDI  R31,HIGH(_curr_lcd)
	RCALL SUBOPT_0xC
; 0000 0311 if(curr_num != -1)   // this means that there was a number on the lcd before ther interrupt
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	CP   R30,R8
	CPC  R31,R9
	BREQ _0xD3
; 0000 0312 {
; 0000 0313 lcd_gotoxy(0,1);
	RCALL SUBOPT_0x8
; 0000 0314 if(check_password)  // means that the number was a PC
	CPI  R17,0
	BREQ _0xD4
; 0000 0315 {
; 0000 0316 while(curr_num != 0)
_0xD5:
	MOV  R0,R8
	OR   R0,R9
	BREQ _0xD7
; 0000 0317 {
; 0000 0318 lcd_printf("*");
	__POINTW1FN _0x0,6
	RCALL SUBOPT_0x3
; 0000 0319 curr_num/=10;
	MOVW R26,R8
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21U
	MOVW R8,R30
; 0000 031A }
	RJMP _0xD5
_0xD7:
; 0000 031B }
; 0000 031C else               // The mumber was an ID
	RJMP _0xD8
_0xD4:
; 0000 031D {
; 0000 031E lcd_printf("%d" , curr_num);
	__POINTW1FN _0x0,224
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R8
	RCALL SUBOPT_0xC
; 0000 031F }
_0xD8:
; 0000 0320 
; 0000 0321 }
; 0000 0322 curr_num=-1;
_0xD3:
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	MOVW R8,R30
; 0000 0323 run_interrupt = false;                    // indicates that the interrupt has ended
	CLR  R10
; 0000 0324 if(check_password) enter_password=true;   // turn on the mode of writing PC (display('*') instead of numeric digits)
	CPI  R17,0
	BREQ _0xD9
	LDI  R30,LOW(1)
	MOV  R11,R30
; 0000 0325 }
_0xD9:
	RJMP _0x2080002
; .FEND
;interrupt[2] void admin_INT0(void)
; 0000 032A {   bool check_password = false;
_admin_INT0:
; .FSTART _admin_INT0
	RCALL SUBOPT_0x1F
; 0000 032B if(enter_password)check_password=true,enter_password=false; // indicates that the user was writing a PC before the interrupt
;	check_password -> R17
	BREQ _0xDA
	LDI  R17,LOW(1)
	CLR  R11
; 0000 032C run_interrupt=true;        // indicates the starting of the interrupt
_0xDA:
	LDI  R30,LOW(1)
	MOV  R10,R30
; 0000 032D admin_interaction();
	RCALL _admin_interaction
; 0000 032E handle_interrupt(check_password);
	RJMP _0xDC
; 0000 032F 
; 0000 0330 }
; .FEND
;interrupt[3] void setPC_INT1(void)
; 0000 0333 {   bool check_password = false;
_setPC_INT1:
; .FSTART _setPC_INT1
	RCALL SUBOPT_0x1F
; 0000 0334 if(enter_password)check_password=true,enter_password=false;
;	check_password -> R17
	BREQ _0xDB
	LDI  R17,LOW(1)
	CLR  R11
; 0000 0335 run_interrupt=true;
_0xDB:
	LDI  R30,LOW(1)
	MOV  R10,R30
; 0000 0336 set_passcode();
	RCALL _set_passcode
; 0000 0337 handle_interrupt(check_password);
_0xDC:
	MOV  R26,R17
	RCALL _handle_interrupt
; 0000 0338 }
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
	ST   -Y,R17
	MOV  R17,R26
	SBRS R17,4
	RJMP _0x2000004
	SBI  0x1B,3
	RJMP _0x2000005
_0x2000004:
	CBI  0x1B,3
_0x2000005:
	SBRS R17,5
	RJMP _0x2000006
	SBI  0x1B,4
	RJMP _0x2000007
_0x2000006:
	CBI  0x1B,4
_0x2000007:
	SBRS R17,6
	RJMP _0x2000008
	SBI  0x1B,5
	RJMP _0x2000009
_0x2000008:
	CBI  0x1B,5
_0x2000009:
	SBRS R17,7
	RJMP _0x200000A
	SBI  0x1B,6
	RJMP _0x200000B
_0x200000A:
	CBI  0x1B,6
_0x200000B:
	__DELAY_USB 13
	SBI  0x1B,2
	__DELAY_USB 13
	CBI  0x1B,2
	__DELAY_USB 13
	RJMP _0x2080002
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 133
	ADIW R28,1
	RET
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R17
	ST   -Y,R16
	MOV  R17,R26
	LDD  R16,Y+2
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	ADD  R30,R16
	MOV  R26,R30
	RCALL __lcd_write_data
	MOV  R13,R16
	MOV  R12,R17
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	RCALL SUBOPT_0x20
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x20
	LDI  R30,LOW(0)
	MOV  R12,R30
	MOV  R13,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R17
	MOV  R17,R26
	CPI  R17,10
	BREQ _0x2000011
	LDS  R30,__lcd_maxx
	CP   R13,R30
	BRLO _0x2000010
_0x2000011:
	LDI  R30,LOW(0)
	ST   -Y,R30
	INC  R12
	MOV  R26,R12
	RCALL _lcd_gotoxy
	CPI  R17,10
	BRNE _0x2000013
	RJMP _0x2080002
_0x2000013:
_0x2000010:
	INC  R13
	SBI  0x1B,0
	MOV  R26,R17
	RCALL __lcd_write_data
	CBI  0x1B,0
	RJMP _0x2080002
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	RCALL __SAVELOCR4
	MOVW R18,R26
_0x2000014:
	MOVW R26,R18
	__ADDWRN 18,19,1
	LD   R30,X
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2000016
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000014
_0x2000016:
_0x2080003:
	RCALL __LOADLOCR4
	ADIW R28,4
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R17
	MOV  R17,R26
	SBI  0x1A,3
	SBI  0x1A,4
	SBI  0x1A,5
	SBI  0x1A,6
	SBI  0x1A,2
	SBI  0x1A,0
	SBI  0x1A,1
	CBI  0x1B,2
	CBI  0x1B,0
	CBI  0x1B,1
	STS  __lcd_maxx,R17
	MOV  R30,R17
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	MOV  R30,R17
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	RCALL _delay_ms
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0x21
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x2080002:
	LD   R17,Y+
	RET
; .FEND

	.CSEG
_strcpy:
; .FSTART _strcpy
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpy0:
    ld   r22,z+
    st   x+,r22
    tst  r22
    brne strcpy0
    movw r30,r24
    ret
; .FEND
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
__print_G102:
; .FSTART __print_G102
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	RCALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2040016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2040018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x204001C
	CPI  R18,37
	BRNE _0x204001D
	LDI  R17,LOW(1)
	RJMP _0x204001E
_0x204001D:
	RCALL SUBOPT_0x22
_0x204001E:
	RJMP _0x204001B
_0x204001C:
	CPI  R30,LOW(0x1)
	BRNE _0x204001F
	CPI  R18,37
	BRNE _0x2040020
	RCALL SUBOPT_0x22
	RJMP _0x20400CC
_0x2040020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2040021
	LDI  R16,LOW(1)
	RJMP _0x204001B
_0x2040021:
	CPI  R18,43
	BRNE _0x2040022
	LDI  R20,LOW(43)
	RJMP _0x204001B
_0x2040022:
	CPI  R18,32
	BRNE _0x2040023
	LDI  R20,LOW(32)
	RJMP _0x204001B
_0x2040023:
	RJMP _0x2040024
_0x204001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2040025
_0x2040024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2040026
	ORI  R16,LOW(128)
	RJMP _0x204001B
_0x2040026:
	RJMP _0x2040027
_0x2040025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x204001B
_0x2040027:
	CPI  R18,48
	BRLO _0x204002A
	CPI  R18,58
	BRLO _0x204002B
_0x204002A:
	RJMP _0x2040029
_0x204002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x204001B
_0x2040029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x204002F
	RCALL SUBOPT_0x23
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	RCALL SUBOPT_0x24
	RJMP _0x2040030
_0x204002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2040032
	RCALL SUBOPT_0x23
	RCALL SUBOPT_0x25
	RCALL _strlen
	MOV  R17,R30
	RJMP _0x2040033
_0x2040032:
	CPI  R30,LOW(0x70)
	BRNE _0x2040035
	RCALL SUBOPT_0x23
	RCALL SUBOPT_0x25
	RCALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2040033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2040036
_0x2040035:
	CPI  R30,LOW(0x64)
	BREQ _0x2040039
	CPI  R30,LOW(0x69)
	BRNE _0x204003A
_0x2040039:
	ORI  R16,LOW(4)
	RJMP _0x204003B
_0x204003A:
	CPI  R30,LOW(0x75)
	BRNE _0x204003C
_0x204003B:
	LDI  R30,LOW(_tbl10_G102*2)
	LDI  R31,HIGH(_tbl10_G102*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x204003D
_0x204003C:
	CPI  R30,LOW(0x58)
	BRNE _0x204003F
	ORI  R16,LOW(8)
	RJMP _0x2040040
_0x204003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2040071
_0x2040040:
	LDI  R30,LOW(_tbl16_G102*2)
	LDI  R31,HIGH(_tbl16_G102*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x204003D:
	SBRS R16,2
	RJMP _0x2040042
	RCALL SUBOPT_0x23
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	LD   R30,X+
	LD   R31,X+
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2040043
	RCALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2040043:
	CPI  R20,0
	BREQ _0x2040044
	SUBI R17,-LOW(1)
	RJMP _0x2040045
_0x2040044:
	ANDI R16,LOW(251)
_0x2040045:
	RJMP _0x2040046
_0x2040042:
	RCALL SUBOPT_0x23
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	__GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
_0x2040046:
_0x2040036:
	SBRC R16,0
	RJMP _0x2040047
_0x2040048:
	CP   R17,R21
	BRSH _0x204004A
	SBRS R16,7
	RJMP _0x204004B
	SBRS R16,2
	RJMP _0x204004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x204004D
_0x204004C:
	LDI  R18,LOW(48)
_0x204004D:
	RJMP _0x204004E
_0x204004B:
	LDI  R18,LOW(32)
_0x204004E:
	RCALL SUBOPT_0x22
	SUBI R21,LOW(1)
	RJMP _0x2040048
_0x204004A:
_0x2040047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x204004F
_0x2040050:
	CPI  R19,0
	BREQ _0x2040052
	SBRS R16,3
	RJMP _0x2040053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2040054
_0x2040053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2040054:
	RCALL SUBOPT_0x22
	CPI  R21,0
	BREQ _0x2040055
	SUBI R21,LOW(1)
_0x2040055:
	SUBI R19,LOW(1)
	RJMP _0x2040050
_0x2040052:
	RJMP _0x2040056
_0x204004F:
_0x2040058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RCALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x204005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x204005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x204005A
_0x204005C:
	CPI  R18,58
	BRLO _0x204005D
	SBRS R16,3
	RJMP _0x204005E
	SUBI R18,-LOW(7)
	RJMP _0x204005F
_0x204005E:
	SUBI R18,-LOW(39)
_0x204005F:
_0x204005D:
	SBRC R16,4
	RJMP _0x2040061
	CPI  R18,49
	BRSH _0x2040063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2040062
_0x2040063:
	RJMP _0x20400CD
_0x2040062:
	CP   R21,R19
	BRLO _0x2040067
	SBRS R16,0
	RJMP _0x2040068
_0x2040067:
	RJMP _0x2040066
_0x2040068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2040069
	LDI  R18,LOW(48)
_0x20400CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x204006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	RCALL SUBOPT_0x24
	CPI  R21,0
	BREQ _0x204006B
	SUBI R21,LOW(1)
_0x204006B:
_0x204006A:
_0x2040069:
_0x2040061:
	RCALL SUBOPT_0x22
	CPI  R21,0
	BREQ _0x204006C
	SUBI R21,LOW(1)
_0x204006C:
_0x2040066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2040059
	RJMP _0x2040058
_0x2040059:
_0x2040056:
	SBRS R16,0
	RJMP _0x204006D
_0x204006E:
	CPI  R21,0
	BREQ _0x2040070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL SUBOPT_0x24
	RJMP _0x204006E
_0x2040070:
_0x204006D:
_0x2040071:
_0x2040030:
_0x20400CC:
	LDI  R17,LOW(0)
_0x204001B:
	RJMP _0x2040016
_0x2040018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LD   R30,X+
	LD   R31,X+
	RCALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_put_lcd_G102:
; .FSTART _put_lcd_G102
	RCALL __SAVELOCR4
	MOVW R16,R26
	LDD  R19,Y+4
	MOV  R26,R19
	RCALL _lcd_putchar
	MOVW R26,R16
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x2080001:
	RCALL __LOADLOCR4
	ADIW R28,5
	RET
; .FEND
_lcd_printf:
; .FSTART _lcd_printf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	ADIW R26,4
	__ADDW2R15
	MOVW R16,R26
	LDI  R30,LOW(0)
	STD  Y+4,R30
	STD  Y+4+1,R30
	STD  Y+6,R30
	STD  Y+6+1,R30
	MOVW R26,R28
	ADIW R26,8
	__ADDW2R15
	LD   R30,X+
	LD   R31,X+
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_lcd_G102)
	LDI  R31,HIGH(_put_lcd_G102)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,8
	RCALL __print_G102
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,8
	POP  R15
	RET
; .FEND

	.CSEG

	.DSEG
_curr_lcd:
	.BYTE 0x37
_personName_S0000018000:
	.BYTE 0x12
__base_y_G100:
	.BYTE 0x4
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	__GETWRN 18,19,0
	__GETWRN 18,19,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1:
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X+
	LD   R31,X+
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RCALL _delay_ms
	RJMP _lcd_clear

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x3:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	RCALL _lcd_printf
	ADIW R28,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(_curr_lcd)
	LDI  R31,HIGH(_curr_lcd)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	RCALL _keypad
	MOV  R5,R30
	LDI  R30,LOW(42)
	CP   R30,R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x7:
	RCALL __SAVELOCR6
	__GETWRN 16,17,0
	__GETWRN 18,19,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x9:
	RCALL _read_lcd
	MOVW R18,R30
	MOVW R26,R18
	RCALL _exist
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA:
	RCALL _lcd_clear
	LDI  R30,LOW(1)
	MOV  R11,R30
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	MOVW R8,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xB:
	RCALL _read_lcd
	MOVW R16,R30
	ST   -Y,R19
	ST   -Y,R18
	MOVW R26,R16
	RCALL _match_ID_PC
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xC:
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	LDI  R24,4
	RCALL _lcd_printf
	ADIW R28,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	__POINTW1FN _0x0,89
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	RCALL __PUTPARD1
	LDI  R24,4
	RCALL _lcd_printf
	ADIW R28,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x10:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x11:
	RCALL __SAVELOCR6
	MOVW R18,R26
	__GETWRS 20,21,6
	__GETWRN 16,17,0
	MOVW R26,R20
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x12:
	__GETWRN 16,17,0
	__GETWRN 18,19,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x13:
	MOVW R30,R20
	__ADDWRN 20,21,1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(48)
	RJMP _EE_Write

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x14:
	MOVW R26,R20
	RCALL _get_id_location
	MOVW R16,R30
	__ADDWRN 16,17,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x15:
	MOVW R30,R16
	__ADDWRN 16,17,1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(48)
	RJMP _EE_Write

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x16:
	ST   -Y,R19
	ST   -Y,R18
	ST   -Y,R17
	ST   -Y,R16
	LDI  R26,LOW(1)
	RJMP _store_number

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	RCALL __SAVELOCR6
	MOVW R20,R26
	__GETWRN 16,17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R18
	CPC  R31,R19
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R16
	CPC  R31,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1A:
	MOVW R30,R20
	__ADDWRN 20,21,1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x1B:
	RCALL _EE_Read
	MOV  R18,R30
	CLR  R19
	ST   -Y,R19
	ST   -Y,R18
	LDI  R26,LOW(6)
	LDI  R27,0
	RCALL _SetBit0
	MOVW R18,R30
	ST   -Y,R19
	ST   -Y,R18
	LDI  R26,LOW(7)
	LDI  R27,0
	RCALL _SetBit0
	MOVW R18,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1C:
	RCALL __SAVELOCR4
	MOVW R16,R26
	__GETWRS 18,19,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	__POINTW1FN _0x0,61
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	MOV  R30,R16
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	RCALL __LSLW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1F:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	ST   -Y,R17
	LDI  R17,0
	TST  R11
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x21:
	LDI  R26,LOW(48)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x22:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x23:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x24:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x25:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	LD   R30,X+
	LD   R31,X+
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;RUNTIME LIBRARY

	.CSEG
__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__INITLOCB:
__INITLOCW:
	PUSH R26
	PUSH R27
	MOVW R26,R22
	ADD  R26,R28
	ADC  R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	POP  R27
	POP  R26
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__LSLW12:
	TST  R30
	MOV  R0,R30
	LDI  R30,8
	MOV  R1,R30
	MOVW R30,R26
	BREQ __LSLW12R
__LSLW12S8:
	CP   R0,R1
	BRLO __LSLW12L
	MOV  R31,R30
	LDI  R30,0
	SUB  R0,R1
	BREQ __LSLW12R
__LSLW12L:
	LSL  R30
	ROL  R31
	DEC  R0
	BRNE __LSLW12L
__LSLW12R:
	RET

__ASRW12:
	TST  R30
	MOV  R0,R30
	LDI  R30,8
	MOV  R1,R30
	MOVW R30,R26
	BREQ __ASRW12R
__ASRW12S8:
	CP   R0,R1
	BRLO __ASRW12L
	MOV  R30,R31
	LDI  R31,0
	SBRC R30,7
	LDI  R31,0xFF
	SUB  R0,R1
	BREQ __ASRW12R
__ASRW12L:
	ASR  R31
	ROR  R30
	DEC  R0
	BRNE __ASRW12L
__ASRW12R:
	RET

__LSRW12:
	TST  R30
	MOV  R0,R30
	LDI  R30,8
	MOV  R1,R30
	MOVW R30,R26
	BREQ __LSRW12R
__LSRW12S8:
	CP   R0,R1
	BRLO __LSRW12L
	MOV  R30,R31
	LDI  R31,0
	SUB  R0,R1
	BREQ __LSRW12R
__LSRW12L:
	LSR  R31
	ROR  R30
	DEC  R0
	BRNE __LSRW12L
__LSRW12R:
	RET

__EQW12:
	CP   R30,R26
	CPC  R31,R27
	LDI  R30,1
	BREQ __EQW12T
	CLR  R30
__EQW12T:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0x7D0
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

;END OF CODE MARKER
__END_OF_CODE:
