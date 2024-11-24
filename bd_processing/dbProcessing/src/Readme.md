En el archivo buildt.sbt, agruegué la siguiente línea "org.apache.spark" %% "spark-sql" % "3.2.4" % Test classifier "tests", 
para poder ejecutar los test utilizando la función checkDF: 

libraryDependencies ++= Seq(
  "org.apache.spark" %% "spark-core" % "3.2.4",
  "org.apache.spark" %% "spark-sql" % "3.2.4",
  "org.apache.spark" %% "spark-sql" % "3.2.4" % Test classifier "tests",
  "org.scalatest" %% "scalatest" % "3.0.8" % Test
