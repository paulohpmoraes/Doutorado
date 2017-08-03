
 * -------------------------------------------------------------------------------------------
 *  CORRELAÇÕES DE SPEARMAN COM O QUOTIENT
 *   Última modificação: 03/ago/2017
 * -------------------------------------------------------------------------------------------

GET
  FILE='C:\Users\Paulo\Google Drive\Doutorado\Tese\SPSS\Tese.sav'.
DATASET NAME Tese WINDOW=FRONT.

DATASET ACTIVATE Tese.

* --- BIS-11 x QUOTIENT

NONPAR CORR
  /VARIABLES=BIS11_ControleInibitorio BIS11_FaltaDePlanejamento BIS11_EscoreTotal
    Quotient_MSS Quotient_ASS Quotient_GSS Quotient_Immobility Quotient_Movements 
    Quotient_Displacement Quotient_Area Quotient_SpatialComplexity Quotient_TemporalScaling 
    Quotient_Accuracy Quotient_Omissions Quotient_Commissions Quotient_Latency Quotient_Variability 
    Quotient_COV Quotient_NumberOfShifts Quotient_Attentive Quotient_Impulsive Quotient_Distracted 
    Quotient_Disengaged
  /PRINT=SPEARMAN TWOTAIL NOSIG
  /MISSING=PAIRWISE.

* --- ASRS-18 x QUOTIENT

NONPAR CORR
  /VARIABLES=ASRS_Desatencao ASRS_Hiperatividade ASRS_Total 
    Quotient_MSS Quotient_ASS Quotient_GSS Quotient_Immobility Quotient_Movements 
    Quotient_Displacement Quotient_Area Quotient_SpatialComplexity Quotient_TemporalScaling 
    Quotient_Accuracy Quotient_Omissions Quotient_Commissions Quotient_Latency Quotient_Variability 
    Quotient_COV Quotient_NumberOfShifts Quotient_Attentive Quotient_Impulsive Quotient_Distracted 
    Quotient_Disengaged
  /PRINT=SPEARMAN TWOTAIL NOSIG
  /MISSING=PAIRWISE.

* --- BDEFS xQUOTIENT

NONPAR CORR
  /VARIABLES=BDEFS_SelfManagementToTime BDEFS_SelfOrganization BDEFS_SelfReinstraint BDEFS_SelfMotivation 
    BDEFS_SelfRegulationOfEmotions BDEFS_TotalEFSummaryScore BDEFS_ADHDEFIndex BDEFS_SintomasFE 
    Quotient_MSS Quotient_ASS Quotient_GSS Quotient_Immobility Quotient_Movements 
    Quotient_Displacement Quotient_Area Quotient_SpatialComplexity Quotient_TemporalScaling 
    Quotient_Accuracy Quotient_Omissions Quotient_Commissions Quotient_Latency Quotient_Variability 
    Quotient_COV Quotient_NumberOfShifts Quotient_Attentive Quotient_Impulsive Quotient_Distracted 
    Quotient_Disengaged
  /PRINT=SPEARMAN TWOTAIL NOSIG
  /MISSING=PAIRWISE.

* --- PSQI e ESS x QUOTIENT

NONPAR CORR
  /VARIABLES=PSQI_SleepLatency PSQI_SleepDuration PSQI_HabitualSleepEfficiency_Temp PSQI_HabitualSleepEfficiency 
    PSQI_SleepDisturbances PSQI_UseOfSleepingMedication PSQI_DaytimeDysfunction PSQI_GlobalPSQIScore ESS_Total
    Quotient_MSS Quotient_ASS Quotient_GSS Quotient_Immobility Quotient_Movements 
    Quotient_Displacement Quotient_Area Quotient_SpatialComplexity Quotient_TemporalScaling 
    Quotient_Accuracy Quotient_Omissions Quotient_Commissions Quotient_Latency Quotient_Variability 
    Quotient_COV Quotient_NumberOfShifts Quotient_Attentive Quotient_Impulsive Quotient_Distracted 
    Quotient_Disengaged
  /PRINT=SPEARMAN TWOTAIL NOSIG
  /MISSING=PAIRWISE.
