##
## Análise dos dados dos atígrafos
##

rm(list=ls())  # Remove todos os objetos
arqresults <- "atigrafia.csv"
setwd("C:/Users/Paulo/Google Drive/Doutorado/Actigraphy/Export")
arquivos <- list.files(pattern = "\\.txt$")

WAKEthreshold   <- 40
MOBILEthreshold <- 0

df <- data.frame(Subject=character(),   # Nome do sujeito
                 tEpochs=integer(),     # Número de épocas coletadas
                 nRemoved=integer(),    # Número de épocas removidas
                 
                 nEpochs=integer(),     # Número de épocas restantes
                 mAC=double(),          # Média de todos os ACs
                 sdAC=double(),         # Desvio padrão de todos os ACs
                 pMOBILE=double(),      # Percentual de épocas classificadas como MOBILE     
                 pWAKE=double(),        # Percentual de épocas classificadas como WAKE
                 
                 nACTIVE=integer(),     # Número de épocas classificadas como ACTIVE
                 A_mAC=double(),        # Média dos ACs no período ACTIVE
                 A_sdAC=double(),       # Desvio padrão dos ACs no período ACTIVE
                 A_pMOBILE=double(),    # Percentual de épocas classificadas como MOBILE no período ACTIVE
                 A_pWAKE=double(),      # Percentual de épocas classificadas como WAKE no período ACTIVE
                 
                 nREST=integer(),       # Número de épocas classificadas como REST
                 R_mAC=double(),        # Média dos ACs no período REST
                 R_sdAC=double(),       # Desvio padrão dos ACs no período REST
                 R_pMOBILE=double(),    # Percentual de épocas classificadas como MOBILE no período REST
                 R_pWAKE=double(),      # Percentual de épocas classificadas como WAKE no período REST

                 nSLEEP=integer(),      # Número de épocas classificadas como SLEEP
                 S_mAC=double(),        # Média dos ACs no período SLEEP
                 S_sdAC=double(),       # Desvio padrão dos ACs no período SLEEP
                 S_pMOBILE=double(),    # Percentual de épocas classificadas como MOBILE no período SLEEP
                 S_pWAKE=double(),      # Percentual de épocas classificadas como WAKE no período SLEEP
                 S_mDuration=double(),
                 S_sdDuration=double(), 
                 S_mLatency=double(),
                 S_dpLatency=double(),
                 S_mSnooze=double(),
                 S_sdSnooze=double(),
                 S_Efficiency=double(),
                 
                 pACTIVE=double(),
                 pSLEEP=double(),
                 pREST=double(),
                 stringsAsFactors=FALSE) 

write.table(df,file=arqresults,sep=";",dec=",",row.names=FALSE,append=FALSE,quote=FALSE)

for(arquivo in arquivos) {

  conexao <- file(arquivo, encoding="UTF-8-BOM")    
  linhas  <- readLines(conexao, warn=FALSE)
  close(conexao)

  ## BUSCA PELO NOME DO SUJEITO
  linha <- 0
  repeat {
    linha <- linha + 1
    if (sub(";.*","",linhas[linha]) == '"Subject Identity:"') {
      Subject <- sub(".*;","",linhas[linha])
      break
    }
    if (linha == length(linhas)) { break }
  }
  rm(linha,linhas)
  
  cat("Processando arquivo:\n",arquivo,"\n")
  
  ## CARREGA OS DADOS
  dados <- read.table(arquivo, header=TRUE, sep=";", quote="", dec=",", na.strings="NaN", 
                      colClasses=c(rep("character",13)),
                      skip=27, blank.lines.skip=TRUE,stringsAsFactors=TRUE, fileEncoding="UTF-8-BOM",nrows=0)
  
  ## REMOVE VARIÁVEIS NÃO USADAS
  dados <- dados[c(-1,-5,-6,-8,-9,-13,-14)]
  
  ## RENOMEIA AS VARIÁVEIS
  colnames(dados) <- c("Epoch","Day","Seconds","Activity","SleepWake","Mobility","IntervalStatus")
  
  ## REMOVE ASPAS
  dados[] <- lapply(dados,function(aux) {gsub('[\"]','',aux)}) # os [] preservam a estrutura de data frame
  
  tEpochs <- nrow(dados) # número total de épocas obtido
  
  ## REMOVE ÉPOCAS EXCLUIDAS
  nRemoved  <- sum(dados$IntervalStatus=='EXCLUDED')    # Número de épocas EXCLUDED
  dados     <- dados[dados$IntervalStatus!='EXCLUDED',] # Remove épocas EXCLUDED
  
  ## RECODIFICA INTERVALOS (ACTIVE=0; REST=1; REST-S=2)
  dados$IntervalStatus[dados$IntervalStatus=="ACTIVE"] <- "0"
  dados$IntervalStatus[dados$IntervalStatus=="REST"]   <- "1"
  dados$IntervalStatus[dados$IntervalStatus=="REST-S"] <- "2"
  
  ## CONVERTE TODAS AS VARIÁVEIS PARA FORMATO NUMÉRICO
  dados[] <- lapply(dados,as.numeric)
  
  ## CONTA ÉPOCAS COM ACs INVÁLIDOS (NaN)
  nRemoved <- nRemoved + sum(is.na(dados$Activity)) # número de épocas removidas
  
  ## REMOVE ÉPOCAS COM ACs INVÁLIDOS (NaN)
  dados <- dados[complete.cases(dados$Activity),]

  nEpochs    <- nrow(dados)
  
  ## LOCALIZA TRANSIÇÕES DE ESTADOS
  bRestS  <- c() # Início do período de descanso antes do sono (Latência)
  eRestS  <- c() # Fim do período de descanson antes do sono (Latência)
  bSleep  <- c() # Início do período de sono (Sono)
  eSleep  <- c() # Fim do período de sono (Sono)
  bRestW  <- c() # Início do período de descanço depois do sono (Snooze)
  eRestW  <- c() # Fim do período de descanço depois do sono (Snooze)
  for (i in 2:(nEpochs)) {
    # Transição de ACTIVE para REST -> início de REST antes de SLEEP
    if(dados$IntervalStatus[i-1] == 0 & dados$IntervalStatus[i] == 1)
    { bRestS <- c(bRestS,i) }
    # Transição de REST para REST-S -> fim de REST e início de SLEEP
    if(dados$IntervalStatus[i-1] == 1 & dados$IntervalStatus[i] == 2)
    { bSleep <- c(bSleep,i)
      eRestS <- c(eRestS,i-1)}
    # Transição de REST-S para REST -> fim de SLEEP e início de REST
    if(dados$IntervalStatus[i-1] == 2 & dados$IntervalStatus[i] == 1)
    { eSleep <- c(eSleep,i-1)
      bRestW <- c(bRestW,i)}
    # Transição de REST para ACTIVE -> fim de REST
    if(dados$IntervalStatus[i-1] == 1 & dados$IntervalStatus[i] == 0)
    { eRestW <- c(eRestW,i-1) }
    # Transição de ACTIVE para REST-S -> início de SLEEP sem REST
    if(dados$IntervalStatus[i-1] == 0 & dados$IntervalStatus[i] == 2)
    { bSleep <- c(bSleep,i) }
    # Transição de REST-S para ACTIVE -> fim de SLEEP sem REST
    if(dados$IntervalStatus[i-1] == 2 & dados$IntervalStatus[i] == 0)
    { eSleep <- c(eSleep,i-1) }
  }
  
  ## ESTATÍSTICAS DA COLETA TODA
  mAC       <- mean(dados$Activity,na.rm=TRUE)
  sdAC      <- sd(dados$Activity,na.rm=TRUE)
  pMOBILE   <- nrow(dados[dados$Mobility==1,]) / nEpochs
  pWAKE     <- nrow(dados[dados$SleepWake==1,]) / nEpochs
  
  ## ESTATÍSTICAS DOS INTERVALOS CLASSIFICADOS COMO ATIVO (=0)
  nACTIVE   <- nrow(dados[dados$IntervalStatus==0,])
  A_mAC     <- mean(dados[dados$IntervalStatus==0,]$Activity,na.rm=TRUE)
  A_sdAC    <- sd(dados[dados$IntervalStatus==0,]$Activity,na.rm=TRUE)
  A_pMOBILE <- nrow(dados[dados$IntervalStatus==0 & dados$Mobility==1,]) / nACTIVE
  A_pWAKE   <- nrow(dados[dados$IntervalStatus==0 & dados$SleepWake==1,]) / nACTIVE
  
  ## ESTATÍSTICAS DOS INTERVALOS CLASSIFICADOS COMO REST (=1)
  nREST     <- nrow(dados[dados$IntervalStatus==1,])
  R_mAC     <- mean(dados[dados$IntervalStatus==1,]$Activity,na.rm=TRUE)
  R_sdAC    <- sd(dados[dados$IntervalStatus==1,]$Activity,na.rm=TRUE)
  R_pMOBILE <- nrow(dados[dados$IntervalStatus==1 & dados$Mobility==1,]) / nREST
  R_pWAKE   <- nrow(dados[dados$IntervalStatus==1 & dados$SleepWake==1,]) / nREST
  
  ## ESTATÍSTICAS DOS INTERVALOS CLASSIFICADOS COMO REST-S (=2)
  nSLEEP       <- nrow(dados[dados$IntervalStatus==2,])
  S_mAC        <- mean(dados[dados$IntervalStatus==2,]$Activity,na.rm=TRUE)
  S_sdAC       <- sd(dados[dados$IntervalStatus==2,]$Activity,na.rm=TRUE)
  S_pMOBILE    <- nrow(dados[dados$IntervalStatus==2 & dados$Mobility==1,]) / nSLEEP
  S_pWAKE      <- nrow(dados[dados$IntervalStatus==2 & dados$SleepWake==1,]) / nSLEEP
  S_Lengths    <- eSleep - bSleep   # Duração dos períodos de sono (em épocas)
  S_mDuration  <- mean(S_Lengths) # Duração média dos períodos de sono (em épocas)
  S_sdDuration <- sd(S_Lengths)   # Desvio padrão da média dos períodos de sono (em épocas)
  S_Latency    <- eRestS - bRestS   # Duração das latências (em épocas)
  S_mLatency   <- mean(S_Latency) # Duração média das latências (em épocas)
  S_sdLatency  <- sd(S_Latency)  # Desvio padrão da média das latências (em épocas)
  S_Snooze     <- eRestW - bRestW     # Duração dos snooze (em épocas)
  S_mSnooze    <- mean(S_Snooze)     # Duração médio dos snooze (em épocas)
  S_sdSnooze   <- sd(S_Snooze)      # Desvio padrão médio dos snooze (em épocas)
  S_Efficiency <- nSLEEP  / (sum(eRestS-bRestS) + nSLEEP)
  
  pACTIVE <- nACTIVE / nEpochs
  pSLEEP  <- nSLEEP  / nEpochs
  pREST   <- nREST   / nEpochs
  
  df = rbind(df,data.frame(Subject,tEpochs,nRemoved,nEpochs,
                           mAC,sdAC,pMOBILE,pWAKE,
                           nACTIVE,A_mAC,A_sdAC,A_pMOBILE,A_pWAKE,
                           nREST,R_mAC,R_sdAC,R_pMOBILE,R_pWAKE,
                           nSLEEP,S_mAC,S_sdAC,S_pMOBILE,S_pWAKE,
                           S_mDuration,S_sdDuration,S_mLatency,S_sdLatency,S_mSnooze,S_sdSnooze,S_Efficiency,
                           pACTIVE,pSLEEP,pREST,
                           stringsAsFactors=FALSE))
}

write.table(df,file=arqresults,sep=";",dec=",",row.names=FALSE,col.names=FALSE,append=TRUE,quote=FALSE)
rm(list=ls())  # Remove todos os objetos
cat("Fim!")