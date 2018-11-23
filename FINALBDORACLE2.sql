--CREACION DE TABLA PEDIDOS 
CREATE TABLE PEDIDOS (
items integer,
cajas_grandes integer,
cajas_pequenas integer,
cantidad_cajas integer
);

CREATE INDEX idx_item ON PEDIDOS(UPPER(items));

--CREACION DE FUNCION PARA CALCULAR CAJAS NECESARIAS 
CREATE OR REPLACE FUNCTION CALCULARCAJAS (ITEM IN NUMBER , CAJAGRANDE IN NUMBER  , CAJAPEQUE IN NUMBER )
RETURN NUMBER IS 
  value_r NUMBER;
  value_G INTEGER;
  valu INTEGER;
  cal_G INTEGER;
BEGIN
  value_r:=0;
  
  valu := (ITEM/5);
  value_G := (CAJAGRANDE*valu);
  
  cal_G :=ITEM/value_G;
  
  IF (cal_G < 0) THEN
    value_r := -1; 
  ELSE
    value_r := valu+cal_G;
  END IF;

  RETURN value_r;
END CALCULARCAJAS;


--PROCEDIMIENTO ALAMACENADO
CREATE OR REPLACE PROCEDURE PROCESARPEDIDOS 
 AS 
  items PEDIDOS.items%TYPE;
  cajas_grandes PEDIDOS.cajas_grandes%TYPE;
  cajas_pequenas PEDIDOS.cajas_pequenas%TYPE;
  cantidad_cajas PEDIDOS.cantidad_cajas%TYPE; 
  base NUMBER ;
  CURSOR CURSOR_PEDIDOS IS
  SELECT  items 
          ,cajas_grandes 
          ,cajas_pequenas 
          ,cantidad_cajas 
  FROM PEDIDOS;
BEGIN
     FOR R_PEDIDOS  IN CURSOR_PEDIDOS LOOP
     
      base := CALCULARCAJAS(R_PEDIDOS.items,R_PEDIDOS.cajas_grandes,R_PEDIDOS.cajas_pequenas); 
      
      IF (base >0) THEN
            
            UPDATE PEDIDOS SET cantidad_cajas = base
            WHERE items = R_PEDIDOS.items; 
      END IF;
          
     END LOOP;
      
END PROCESARPEDIDOS;



--CREACION DE ARRAY
DECLARE
  a_values NUM_ARRAY := NUM_ARRAY(null);
  b_values NUM_ARRAY := NUM_ARRAY(null);
  v_Return NUMBER;
BEGIN
  a_values := NUM_ARRAY(-2,-3,4,-1,-2,1,5,-3);
  b_values := NUM_ARRAY(4,-1,-2,1,5); 
  
  v_Return := FUNCTION1(PARAM1 => b_values,PARAM2 =>a_values);
  dbms_output.put_line('La suma de los array es: ' ||v_Return);
END;



--CREATE TYPE number_array AS VARRAY(50) OF INTEGER;

---NO FUNCIONA
/*
CREATE OR  REPLACE FUNCTION LARGESTSUM (PARAM1 IN NUM_ARRAY,PARAM2 IN  NUM_ARRAY ) 
RETURN NUMBER IS 
value_r NUMBER;
new_sum INTEGER;
BEGIN
      value_r:=0;
      
      FOR i IN 1..PARAM2.COUNT
        LOOP
        value_a :=a_values(i)**2;
        v_Return := FUNCTION1(PARAM1 => b_values,PARAM2 =>value_a);
        :v_Return := v_Return;
        dbms_output.put_line('El elemento : '||a_values(i)**2||' EXISTE '||v_Return);
      END LOOP;
      
      FOR i IN PARAM1.FIRST..PARAM1.LAST LOOP
      
        new_sum:=new_sum+a_values(i);
        IF PARAM1.EXISTS(PARAM2) THEN
          value_r := 'TRUE'; 
        ELSE
         value_r :='FALSE';
        END IF;
      END LOOP;
      
      RETURN value_r ;
END FUNCTION1;

*/
