* Design Problem, ee114/214A- 2018
* Team Member 1 Name: Maggie Ford
* Team Member 2 Name: Andrea Ramirez
* Please fill in the specification achieved by your circuit 
* before you submit the netlist.
**************************************************************
* sunetids of team members = 
* The specifications that this script achieves are: 
* Power  =    
* Gain   =    
* BandWidth =
* Spot Noise @ 1kHz =    
* FOM = 
***************************************************************

** Including the model file
.include /afs/ir.stanford.edu/class/ee114/hspice/ee114_hspice.sp

* Defining Top level circuit parameters
.param Cin = 100f
.param CL  = 250f
.param RL  = 20k

* defining the supply voltages

vdd vdd 0 2.5
vss vss 0 -2.5

* Defining the input current source

* Note, having each source with ac magnitude of 0.5 (as below) ensures a differential input magnitude of 1
** For ac simulation uncomment the following 2 lines** 
 Iina		iina	vdd	ac	0.5	
 Iinb		vdd	iinb	ac	0.5	

** For transient simulation uncomment the following 2 lines**
*Iina		iina	vdd	sin(0 0.5u 1e6)
*Iinb		vdd	iinb	sin(0 0.5u 1e6)

* Defining Input capacitance

Cina	vdd	iina 'Cin'
Cinb	vdd	iinb 'Cin'

* Defining the differential load 

RL	vouta		voutb		'RL'
CL	vouta		voutb		'CL'

*** Your Trans-impedance Amplifier here ***
***	d	g	s	b	n/pmos114	w	l

*** A Side ***
m1a   dra    0    iina   vss  nmos114  w=4u l=2u
ml1a  dra    vbp  vdd    vdd  pmos114  w=4u l=2u
mb1a  iina   vbn  vss    vss  nmos114  w=4u l=2u
ml2a  vdd    vdd  sla    vss  nmos114  w=4u l=2u
m2a   sla    dra  sba    vss  nmos114  w=4u l=2u
mb2a  sba    vbn  vss    vss  nmos114  w=4u l=2u
m3a   vdd    sla  vouta  vss  nmos114  w=4u l=2u
mb3a  vouta  vbn  vss    vss  nmos114  w=4u l=2u

*** B Side ***
m1b   drb    0    iinb   vss  nmos114  w=4u l=2u
ml1b  drb    vbp  vdd    vdd  pmos114  w=4u l=2u
mb1b  iinb   vbn  vss    vss  nmos114  w=4u l=2u
ml2b  vdd    vdd  slb    vss  nmos114  w=4u l=2u
m2b   slb    drb  sba    vss  nmos114  w=4u l=2u
mb2b  sba    vbn  vss    vss  nmos114  w=4u l=2u
m3b   vdd    slb  voutb  vss  nmos114  w=4u l=2u
mb3b  voutb  vbn  vss    vss  nmos114  w=4u l=2u

*** Current Bias ***


*** Your Bias Circuitry here ***
vbiasp vbp 0  1.9
vbiasn vbn 0  -1.9 

rua   vdd   dra    10k
rda   dra   vss    10k
rub   vdd   drb    10k
rdb   dra   vss    10k  

* defining the analysis

.op
.option post brief nomod

** For ac simulation uncomment the following line** 
.ac dec 1k 100 1g
* add line for noise simulation

.measure ac gainmaxa max vdb(vouta)
.measure ac f3dba when vdb(vouta)='gainmaxa-3'

.measure ac gainmaxb max vdb(voutb)
.measure ac f3dbb when vdb(voutb)='gainmaxb-3'

* Note, the statement below gives you the differential gain
.measure ac gaindiff max vdb(vouta, voutb)

** For transient simulation uncomment the following line **
*.tran 0.01u 4u 

.end

