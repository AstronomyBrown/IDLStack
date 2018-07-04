/**
 * BinaryExprType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package net.ivoa.www.xml.ADQL.v0_7_4;

public class BinaryExprType  extends net.ivoa.www.xml.ADQL.v0_7_4.ScalarExpressionType  implements java.io.Serializable {
    private net.ivoa.www.xml.ADQL.v0_7_4.ScalarExpressionType[] arg;
    private net.ivoa.www.xml.ADQL.v0_7_4.BinaryOperatorType oper;  // attribute

    public BinaryExprType() {
    }


    /**
     * Gets the arg value for this BinaryExprType.
     * 
     * @return arg
     */
    public net.ivoa.www.xml.ADQL.v0_7_4.ScalarExpressionType[] getArg() {
        return arg;
    }


    /**
     * Sets the arg value for this BinaryExprType.
     * 
     * @param arg
     */
    public void setArg(net.ivoa.www.xml.ADQL.v0_7_4.ScalarExpressionType[] arg) {
        this.arg = arg;
    }

    public net.ivoa.www.xml.ADQL.v0_7_4.ScalarExpressionType getArg(int i) {
        return this.arg[i];
    }

    public void setArg(int i, net.ivoa.www.xml.ADQL.v0_7_4.ScalarExpressionType value) {
        this.arg[i] = value;
    }


    /**
     * Gets the oper value for this BinaryExprType.
     * 
     * @return oper
     */
    public net.ivoa.www.xml.ADQL.v0_7_4.BinaryOperatorType getOper() {
        return oper;
    }


    /**
     * Sets the oper value for this BinaryExprType.
     * 
     * @param oper
     */
    public void setOper(net.ivoa.www.xml.ADQL.v0_7_4.BinaryOperatorType oper) {
        this.oper = oper;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof BinaryExprType)) return false;
        BinaryExprType other = (BinaryExprType) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = super.equals(obj) && 
            ((this.arg==null && other.getArg()==null) || 
             (this.arg!=null &&
              java.util.Arrays.equals(this.arg, other.getArg()))) &&
            ((this.oper==null && other.getOper()==null) || 
             (this.oper!=null &&
              this.oper.equals(other.getOper())));
        __equalsCalc = null;
        return _equals;
    }

    private boolean __hashCodeCalc = false;
    public synchronized int hashCode() {
        if (__hashCodeCalc) {
            return 0;
        }
        __hashCodeCalc = true;
        int _hashCode = super.hashCode();
        if (getArg() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getArg());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getArg(), i);
                if (obj != null &&
                    !obj.getClass().isArray()) {
                    _hashCode += obj.hashCode();
                }
            }
        }
        if (getOper() != null) {
            _hashCode += getOper().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(BinaryExprType.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "binaryExprType"));
        org.apache.axis.description.AttributeDesc attrField = new org.apache.axis.description.AttributeDesc();
        attrField.setFieldName("oper");
        attrField.setXmlName(new javax.xml.namespace.QName("", "Oper"));
        attrField.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "binaryOperatorType"));
        typeDesc.addFieldDesc(attrField);
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("arg");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "Arg"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "scalarExpressionType"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
    }

    /**
     * Return type metadata object
     */
    public static org.apache.axis.description.TypeDesc getTypeDesc() {
        return typeDesc;
    }

    /**
     * Get Custom Serializer
     */
    public static org.apache.axis.encoding.Serializer getSerializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanSerializer(
            _javaType, _xmlType, typeDesc);
    }

    /**
     * Get Custom Deserializer
     */
    public static org.apache.axis.encoding.Deserializer getDeserializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanDeserializer(
            _javaType, _xmlType, typeDesc);
    }

}
