#' @title Distribution plot
#' @export
#' @importFrom ggplot2 ggplot aes stat_function theme margin element_text element_line
#' element_blank labs
library(ggplot2)
library(gofer)
library(patchwork)
library(readxl)

study_data = read.csv("review_69353_extracted_data_csv_20200601072844.csv")

make_dist_plot <- function(study_data, ma_results) {

  bias <- study_data$meanbias
  s2_unb = study_data$s2
  pooled_bias = ma_results$bias_mean
  pooled_sd = ma_results$sd2_est
  pooled_tau2 = ma_results$tau_est
  pooled_sd = sqrt(pooled_sd + pooled_tau2)

  LOA_l = ma_results$LOA_L
  LOA_u = ma_results$LOA_U
  LOA_l_CI = ma_results$CI_L_rve
  LOA_u_CI = ma_results$CI_U_rve

  g <- ggplot(data.frame(x=seq(-50,50,length=200)), aes(x=x)) +
    stat_function(fun=dnorm, args = list(bias[1], sd=sqrt(s2_unb[1])), colour = "cornflowerblue", size=0.6, alpha = 0.5)

  for (i in 2:length(bias)){
    g <- g + stat_function(fun=dnorm, args = list(bias[i], sd=sqrt(s2_unb[i])), color = "cornflowerblue", size = 0.6, alpha = 0.5)
  }

  g <- g + stat_function(fun=dnorm, args = list(pooled_bias, pooled_sd), colour ="lightcoral", alpha = 0.5) +
    stat_function(fun=dnorm, args = list(pooled_bias, pooled_sd), colour = NA, geom="area", fill="lightcoral", alpha = 0.6) +
    #scale_x_continuous(limits = c(-3.5,3.5), breaks = c(-2, -1, 0, 1, 2)) +
    labs(x = expression('Difference between invasive and CNAP blood pressure measurements (mmHg)'),
         caption = "Blue curves are distributions of the differences between measurements from CNAP and invasive\narterial blood pressure measurements in individual studies. The red curve is the distribution of the \npooled estimate.")+
    #scale_y_continuous(name = "Density \n", limits = c(0,2.5)) +
    #labs(title = "\nOuter confidence intervals for pooled limits of agreement\n\n  Pooled limits of agreement")+
    theme(plot.title = element_text(hjust = 0.5, margin = margin(t=10, b=-32), size=10),
          axis.text=element_text(hjust = 0.5, size=10),
          axis.title=element_text(hjust = 0.5, size=10),
          axis.line=element_line(colour="black", size=0.2),
          panel.background = element_blank(),
          axis.ticks = element_blank(),
          plot.caption = element_text(hjust = 0)) #+
  
g
  }
