package examen

import org.apache.spark.rdd.RDD
import org.apache.spark.sql.types.{IntegerType, StringType, DoubleType, StructField, StructType}
import org.scalatest.Matchers.convertToAnyShouldWrapper
import utils.TestInit

class examenTest extends TestInit {
  val sc = spark.sparkContext

  "ejercicio 1 " should "filtrar los estudiantes con una calificación > 8, seleccionar los nombres de los estudiantes " +
    "y ordenarlos por calificación de forma descendente." in {

    import spark.implicits._
    val dfEstud = Seq(
      ("Jorge", 20, 9),
      ("María", 21, 8),
      ("Justina", 22, 7),
      ("Ana", 21, 10),
      ("Julio", 19, 5),
      ("Ivan", 23, 6)
    ).toDF("nombre", "edad", "calificacion")


    val expected = Seq(
      ("Ana", 10),
      ("Jorge", 9)
    ).toDF("nombre", "calificacion")

    val res = examen.ejercicio1(dfEstud)(spark)
    checkDf(expected, res)
    //res.show()
  }

  "ejercicio 2 " should "Definir la paridad del numero de nota de data frame de alumnos " in {
    import spark.implicits._
    val dfEstud = Seq(
      ("Jorge", 20, 9),
      ("Maria", 21, 8),
      ("Justina", 22, 7),
      ("Ana", 21, 10),
      ("Julio", 19, 5),
      ("Ivan", 23, 6)
    ).toDF("nombre", "edad", "calificacion")

    val expected = Seq(
      ("Jorge", 20, 9, "Impar"),
      ("Maria", 21, 8, "Par"),
      ("Justina", 22, 7, "Impar"),
      ("Ana", 21, 10, "Par"),
      ("Julio", 19, 5, "Impar"),
      ("Ivan", 23, 6, "Par")
    ).toDF("nombre", "edad", "calificacion", "paridad")


    val paridad = dfEstud.col("calificacion")
    val res = examen.ejercicio2(dfEstud, "calificacion")(spark)

    res.show()
    checkDf(expected, res)
  }

  "ejercicio 3 " should "realizar un join entre dos dataframes (uno con información de estudiantes (id, nombre) y " +
    "otro con calificaciones (id_estudiante, asignatura, calificacion) y calcular el promedio de calificaciones" +
    " por estudiante" in {

    import spark.implicits._
    val dfEstud1 = Seq(
      (1, "Jorge"),
      (2, "Maria"),
      (3, "Justina")
    ).toDF("id", "nombre")

    val dfEstud2 = Seq(
      (1, "Matematicas", 6),
      (1, "Biologia", 8),
      (1, "Historia", 7),
      (1, "Geografia", 10),
      (2, "Matematicas", 4),
      (2, "Biologia", 8),
      (2, "Historia", 8),
      (2, "Geografia", 6),
      (3, "Matematicas", 5),
      (3, "Biologia", 8),
      (3, "Historia", 4),
      (3, "Geografia", 9),
    ).toDF("id_estudiante", "asignatura", "calificacion")


    val expectedSchema = StructType(Seq(
      StructField("id", IntegerType, false),
      StructField("nombre", StringType, true),
      StructField("promedio", DoubleType, true)
    ))
    val expected = Seq(
      (1, "Jorge", 7.75),
      (2, "Maria", 6.5),
      (3, "Justina", 6.5)
    ).toDF("id","nombre", "promedio")
    val expectedWithSchema = spark.createDataFrame(expected.rdd, expectedSchema)


    val output = examen.ejercicio3(dfEstud1, dfEstud2)

    output.printSchema()
    expectedWithSchema.printSchema()
    output.show()
    checkDf(expectedWithSchema, output)
  }

  "ejercicio 4 " should "do ejercicio 4" in {
    import spark.implicits._
    val listaPalabras = List("hola")

    val expectedData = Seq(
      ("Alice", 25),
      ("Bob", 30),
      ("Charlie", 35),
      ("Diana", 28)
    )

    // Step 3: Create an RDD from the Sequence
    val expectedRDD = sc.parallelize(expectedData)

    val output = examen.ejercicio4(listaPalabras)(spark)

    // Show the result
    println(output)
    //checkDf(expectedRDD, output)
  }

  "ejercicio 5 " should "Calcular y agregar una columna de ingreso total al df de ventas" in {


    val ventasSchema = StructType(Seq(
      StructField("id_venta", IntegerType, true),
      StructField("id_producto", IntegerType, true),
      StructField("cantidad", IntegerType, true),
      StructField("precio_unitario", DoubleType, true)
    ))
    val in = spark.read.format("csv")
      .option("header", "true")
      .schema(ventasSchema)
      .load("src/test/resources/examen/ventas.csv")

    val output = examen.ejercicio5(in)(spark)

    // Show the result
    output.show(false)
  }
}

