$joy_userdata = (C:\triton\bin\mdata-get.exe user-data)

if ($joy_userdata -ne "No metadata for user-data") {
  $joy_userdata | Out-File C:\triton\tmp\mdata-user-data
}
