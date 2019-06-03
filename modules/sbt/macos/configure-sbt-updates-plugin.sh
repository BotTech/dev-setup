#!/usr/bin/env bash

text='addSbtPlugin("com.timushev.sbt" % "sbt-updates" % "0.4.0")'
add_to_file ~/.sbt/1.0/plugins/sbt-updates.sbt "${text}"
add_to_file ~/.sbt/1.0/plugins/plugins/sbt-updates.sbt "${text}"
add_to_file ~/.sbt/0.13/plugins/sbt-updates.sbt "${text}"
add_to_file ~/.sbt/0.13/plugins/plugins/sbt-updates.sbt "${text}"
