#!/usr/bin/env bash

text='addSbtPlugin("net.virtual-void" % "sbt-dependency-graph" % "0.9.2")'
add_to_file ~/.sbt/1.0/plugins/sbt-updates.sbt "${text}"
add_to_file ~/.sbt/1.0/plugins/plugins/sbt-updates.sbt "${text}"
add_to_file ~/.sbt/0.13/plugins/sbt-updates.sbt "${text}"
add_to_file ~/.sbt/0.13/plugins/plugins/sbt-updates.sbt "${text}"
