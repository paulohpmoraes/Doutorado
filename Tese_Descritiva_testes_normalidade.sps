
 * -------------------------------------------------------------------------------------------
 * ESTATÍSTICAS DESCRITIVAS E TESTES DE NORMALIDADE
 *   Última modificação: 03/ago/2017
 * -------------------------------------------------------------------------------------------

GET
  FILE='C:\Users\Paulo\Google Drive\Doutorado\Tese\SPSS\Tese_Dados.sav'.
DATASET NAME Tese WINDOW=FRONT.

DATASET ACTIVATE Tese.

 *  --- SEXO, IDADE E EDUCAÇÃO

FREQUENCIES VARIABLES=Sex
  /ORDER=ANALYSIS.

DESCRIPTIVES VARIABLES=Age Education
  /STATISTICS=MEAN STDDEV MIN MAX.

SORT CASES  BY Sex.
SPLIT FILE LAYERED BY Sex.

DESCRIPTIVES VARIABLES=Age Education
  /STATISTICS=MEAN STDDEV MIN MAX.

SPLIT FILE OFF.

* --- BIS-11

EXAMINE VARIABLES=BIS11_ControleInibitorio BIS11_FaltaDePlanejamento BIS11_EscoreTotal
  /PLOT BOXPLOT HISTOGRAM NPPLOT
  /COMPARE GROUPS
  /STATISTICS DESCRIPTIVES EXTREME
  /CINTERVAL 95
  /MISSING LISTWISE
  /NOTOTAL.

* --- ASRS-18

EXAMINE VARIABLES=ASRS_Desatencao ASRS_Hiperatividade ASRS_Total
  /PLOT BOXPLOT HISTOGRAM NPPLOT
  /COMPARE GROUPS
  /STATISTICS DESCRIPTIVES EXTREME
  /CINTERVAL 95
  /MISSING LISTWISE
  /NOTOTAL.

* --- BDEFS

EXAMINE VARIABLES=BDEFS_SelfManagementToTime BDEFS_SelfOrganization BDEFS_SelfReinstraint 
    BDEFS_SelfMotivation BDEFS_SelfRegulationOfEmotions BDEFS_TotalEFSummaryScore BDEFS_ADHDEFIndex 
    BDEFS_SintomasFE
  /PLOT BOXPLOT HISTOGRAM NPPLOT
  /COMPARE GROUPS
  /STATISTICS DESCRIPTIVES EXTREME
  /CINTERVAL 95
  /MISSING LISTWISE
  /NOTOTAL.

* --- PSQI e ESS

*     Frequências das variáveis categóricas

FREQUENCIES VARIABLES=PSQI_SubjectiveSleepQuality PSQI_SleepLatency PSQI_SleepDuration 
    PSQI_HabitualSleepEfficiency PSQI_SleepDisturbances PSQI_UseOfSleepingMedication 
    PSQI_DaytimeDysfunction PSQI_GlobalPSQIScore
  /STATISTICS=MODE
  /ORDER=ANALYSIS.

*     Descritiva das variáveis não categóricas

EXAMINE VARIABLES=PSQI_HabitualSleepEfficiency_Temp ESS_Total
  /PLOT BOXPLOT HISTOGRAM NPPLOT
  /COMPARE GROUPS
  /STATISTICS DESCRIPTIVES EXTREME
  /CINTERVAL 95
  /MISSING LISTWISE
  /NOTOTAL.

* --- QUOTIENT

EXAMINE VARIABLES=Quotient_MSS Quotient_ASS Quotient_GSS Quotient_Immobility Quotient_Movements 
    Quotient_Displacement Quotient_Area Quotient_SpatialComplexity Quotient_TemporalScaling 
    Quotient_Accuracy Quotient_Omissions Quotient_Commissions Quotient_Latency Quotient_Variability 
    Quotient_COV Quotient_NumberOfShifts Quotient_Attentive Quotient_Impulsive Quotient_Distracted 
    Quotient_Disengaged
  /PLOT BOXPLOT HISTOGRAM NPPLOT
  /COMPARE GROUPS
  /STATISTICS DESCRIPTIVES EXTREME
  /CINTERVAL 95
  /MISSING LISTWISE
  /NOTOTAL.

* --- ATIGRAFIA

DESCRIPTIVES VARIABLES=tEpochs nRemoved nEpochs
  /STATISTICS=MEAN STDDEV MIN MAX.

EXAMINE VARIABLES=mAC sdAC pMOBILE pWAKE A_pACTIVE R_pREST S_pSLEEP S_mDuration S_sdDuration 
    S_mLatency S_dpLatency S_mSnooze S_sdSnooze S_Efficiency A_mAC A_sdAC A_pMOBILE A_pWAKE R_mAC 
    R_sdAC R_pMOBILE R_pWAKE S_mAC S_sdAC S_pMOBILE S_pWAKE
  /PLOT BOXPLOT HISTOGRAM NPPLOT
  /COMPARE GROUPS
  /STATISTICS DESCRIPTIVES EXTREME
  /CINTERVAL 95
  /MISSING LISTWISE
  /NOTOTAL.

