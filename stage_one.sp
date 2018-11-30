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

* Defining Low level circuit parameters
.param Ru = 15k
.param Rd = 485k

* defining the supply voltages
vdd vdd 0 2.5
vss vss 0 -2.5


* defining load mosfet parameters
.param wl1 = 1000u
.param ll1 = 2u
*.param wl2 = 4u
*.param ll2 = 2u

* defining the mosfet parameters
.param w1 = 500u
.param l1 = 2u
*.param w2 = 30u
*.param l2 = 2u
*.param w3 = 4u
*.param l3 = 2u

* defining bias mosfet parameters
.param wb1 = 500u
.param lb1 = 2u
*.param wb2 = 4u
*.param lb2 = 2u
*.param wb3 = 4u
*.param lb3 = 2u

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
*RL	vouta		voutb		'RL'
*CL	vouta		voutb		'CL'

*** Your Trans-impedance Amplifier here ***
***	d	g	s	b	n/pmos114	w	l

**stage one, output is dra/drb

*** A Side ***
m1a   vouta    0    iina   vss  nmos114  w=w1 l=l1
ml1a  vouta    vbp  vdd    vdd  pmos114  w=wl1 l=ll1
mb1a  iina   vbn  vss    vss  nmos114  w=wb1 l=lb1
*ml2a  vdd    vdd  sla    vss  nmos114  w=wl2 l=ll2
*m2a   sla    dra  sba    vss  nmos114  w=w2 l=l2
*mb2a  sba    vbn  vss    vss  nmos114  w=wb2 l=lb2
*m3a   vdd    sla  vouta  vss  nmos114  w=w3 l=l3
*mb3a  vouta  vbn  vss    vss  nmos114  w=wb3 l=lb3

*** B Side ***
m1b   voutb    0    iinb   vss  nmos114  w=w1 l=l1
ml1b  voutb    vbp  vdd    vdd  pmos114  w=wl1 l=ll1
mb1b  iinb   vbn  vss    vss  nmos114  w=wb1 l=lb1
*ml2b  vdd    vdd  slb    vss  nmos114  w=wl2 l=ll2
*m2b   slb    drb  sba    vss  nmos114  w=w2 l=l2
*mb2b  sba    vbn  vss    vss  nmos114  w=wb2 l=lb2
*m3b   vdd    slb  voutb  vss  nmos114  w=w3 l=l3
*mb3b  voutb  vbn  vss    vss  nmos114  w=wb3 l=lb3

*** Current Bias ***
*** Your Bias Circuitry here ***
vbiasp vbp 0  1.85

vbiasn vbn 0  -1.85 

rua   vdd   vouta    Ru
rda   vouta   vss    Rd
rub   vdd   voutb    Ru
rdb   voutb   vss    Rd  

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


