#!/bin/bash
#
# Download latest terraform binary available from Official Terraform website
#

## FUNCTIONS ##

make_download_url()
{
  echo in progress
}

get_current_version()
{
  wget -q -O - "$version_url" |
  awk '

BEGIN { state = 0; }

state == 0 && tolower($0) ~ /latest version/ { state = 1; }

state == 1 && $0 ~ /[0-9]+\.[0-9]+\.[0-9]+/ \
 {
   gsub(/[()]/, " ");

   split($0, ver_a, " ");

   for (i in ver_a)
   {
     if (ver_a[i] ~ /[0-9]+\.[0-9]+\.[0-9]+/)
     {
       print ver_a[i]
     }
   }

   state = 2
 }
' 

}

## ENV ##

version_url="https://www.terraform.io/downloads.html"

## MAIN ##

get_current_version

## EOF ##
