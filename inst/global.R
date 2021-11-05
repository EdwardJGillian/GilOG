library(shiny)
library(dplyr)
library(tidyr)
library(DT)
library(readxl)
library(ggplot2)
library(ggpubr)
library(magrittr)
library(rlang)
library(shinyWidgets)
library(summarytools)
library(GilOG)


# HTML help text for organism file

org_help_text <-  '<div class="panel panel-primary">
  <div class="panel-heading"> <span style="padding-left:10px"><b> Organisms file description</b> </span></div>
<div class="panel-body">
<style type="text/css">
.tg {
border-collapse: collapse;
border-spacing: 0;
border: none;
}
.tg td {
font-family: Arial, sans-serif;
font-size: 14px;
padding: 10px 5px;
border-style: solid;
border-width: 0px;
overflow: hidden;
word-break: normal;
}
.tg th {
font-family: Arial, sans-serif;
font-size: 14px;
font-weight: normal;
padding: 10px 5px;
border-style: solid;
border-width: 0px;
overflow: hidden;
word-break: normal;
}
.tg .tg-s6z2 {
text-align: center
}
</style>
<table class="tg">
<tr>
<th class="tg-031e"> <span class="label label-primary"> Format</span></th>
<th class="tg-031e"> comma-separated values (CSV)
</tr>
<tr>
<th class="tg-031e"> <span class="label label-primary"> Column 1</span></th>
<th class="tg-031e"> row number
</tr>
<tr>
<th class="tg-031e"> <span class="label label-primary"> Columns 2-5</span></th>
<th class="tg-031e"> organism, kingdom, taxonomy id, assembly </th>
</tr>
<tr>
</table>
</div>
</div>'

# HTML help text for gene file
gene_help_text <-  '<div class="panel panel-primary">
  <div class="panel-heading"> <span style="padding-left:10px"><b> Genes file description</b> </span></div>
<div class="panel-body">
<style type="text/css">
.tg {
border-collapse: collapse;
border-spacing: 0;
border: none;
}
.tg td {
font-family: Arial, sans-serif;
font-size: 14px;
padding: 10px 5px;
border-style: solid;
border-width: 0px;
overflow: hidden;
word-break: normal;
}
.tg th {
font-family: Arial, sans-serif;
font-size: 14px;
font-weight: normal;
padding: 10px 5px;
border-style: solid;
border-width: 0px;
overflow: hidden;
word-break: normal;
}
.tg .tg-s6z2 {
text-align: center
}
</style>
<table class="tg">
<tr>
<th class="tg-031e"> <span class="label label-primary"> Format</span></th>
<th class="tg-031e"> comma-separated values (CSV)
</tr>
<tr>
<th class="tg-031e"> <span class="label label-primary"> Column 1</span></th>
<th class="tg-031e"> row number
</tr>
<tr>
<th class="tg-031e"> <span class="label label-primary"> Columns 2-9</span></th>
<th class="tg-031e"> assembly, locus_tag, protein_id, protein, gene_name, strand, location_start, location_end </th>
</tr>
<tr>
</table>
</div>
</div>'
