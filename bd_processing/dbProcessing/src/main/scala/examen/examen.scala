package examen

import org.apache.spark.rdd.RDD
import org.apache.spark.sql.catalyst.dsl.expressions.{DslAttr, DslExpression, StringToAttributeConversionHelper}
import org.apache.spark.sql.catalyst.expressions.SizeBasedWindowFunction.n
import org.apache.spark.sql.{DataFrame, SparkSession}
import org.apache.spark.sql.functions._

import scala.Console.println

object examen {

  /**Ejercicio 1: Crear un DataFrame y realizar operaciones básicas
  Pregunta: Crea un DataFrame a partir de una secuencia de tuplas que contenga información sobre
              estudiantes (nombre, edad, calificación).
            Realiza las siguientes operaciones:

            Muestra el esquema del DataFrame.
            Filtra los estudiantes con una calificación mayor a 8.
            Selecciona los nombres de los estudiantes y ordénalos por calificación de forma descendente.
   */
  def ejercicio1(estudiantes: DataFrame)(spark:SparkSession): DataFrame = {
    estudiantes.printSchema()
    val estudiantesFilt = estudiantes.filter(col("calificacion") > 8).select("nombre", "calificacion").orderBy(
      col("calificacion").desc)

    println("Estudiantes con calificación mayor a 8:")
    estudiantesFilt
  }

  /**Ejercicio 2: UDF (User Defined Function)
  Pregunta: Define una función que determine si un número es par o impar.
            Aplica esta función a una columna de un DataFrame que contenga una lista de números.
   */
  def ejercicio2(numeros: DataFrame, nombreColumna: String)(spark:SparkSession): DataFrame =  {
    val udfparOImpar = udf((n: Int) => if (n % 2 == 0) "Par" else "Impar")

    numeros.withColumn("paridad", udfparOImpar(col(nombreColumna)))
  }

  /**Ejercicio 3: Joins y agregaciones
  Pregunta: Dado dos DataFrames,
            uno con información de estudiantes (id, nombre)
            y otro con calificaciones (id_estudiante, asignatura, calificacion),
            realiza un join entre ellos y calcula el promedio de calificaciones por estudiante.
  */
  def ejercicio3(estudiantes: DataFrame , calificaciones: DataFrame): DataFrame = {

    val dfJoin = estudiantes.join(calificaciones, estudiantes("id") === calificaciones("id_estudiante"), "inner")

    val dfPromedio = dfJoin.groupBy("id", "nombre").agg(avg("calificacion").alias("promedio")).orderBy("id")

   dfPromedio

  }

  /**Ejercicio 4: Uso de RDDs
  Pregunta: Crea un RDD a partir de una lista de palabras y cuenta la cantidad de ocurrencias de cada palabra.

  */

  def ejercicio4(palabras: List[String])(spark:SparkSession): RDD[(String, Int)] = {
    val rdd = Seq(
      ("Jorge", 20, 9),
      ("María", 21, 8.5),
      ("Justina", 22, 7.7),
      ("Ana", 21, 9.5),
      ("Julio",19 , 5.0),
      ("Ivan", 23, 6.7)
    )
    spark.sparkContext.parallelize(rdd).map(x => (x._1, x._2))
  }
  /**
  Ejercicio 5: Procesamiento de archivos
  Pregunta: Carga un archivo CSV que contenga información sobre
            ventas (id_venta, id_producto, cantidad, precio_unitario)
            y calcula el ingreso total (cantidad * precio_unitario) por producto.
  */
  def ejercicio5(ventas: DataFrame)(spark:SparkSession): DataFrame = {
    ventas
  }

}
