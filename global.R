library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(shinyWidgets)
library(data.table)
library(openxlsx)
library(magrittr)
library(googledrive)
library(googlesheets4)
library(DT)
library(rhandsontable)

data.url <- 'https://docs.google.com/spreadsheets/d/1_nEuDiSemqt4eULi17_er4mAu54JKkBalFb6wmQeXtE/'

options(gargle_oauth_cache = ".secrets")

drive_auth(cache = ".secrets", email = "pli@westswan.com")
gs4_auth(token = drive_token())

