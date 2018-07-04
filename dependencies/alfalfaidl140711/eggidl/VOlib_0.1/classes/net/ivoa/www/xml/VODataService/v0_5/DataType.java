/**
 * DataType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package net.ivoa.www.xml.VODataService.v0_5;

public class DataType  implements java.io.Serializable, org.apache.axis.encoding.SimpleType {
    private net.ivoa.www.xml.VODataService.v0_5.ScalarDataType value;
    private org.apache.axis.types.Token arraysize;  // attribute

    public DataType() {
    }

    // Simple Types must have a String constructor
    public DataType(net.ivoa.www.xml.VODataService.v0_5.ScalarDataType value) {
        this.value = value;
    }
    public DataType(java.lang.String value) {
        this.value =net.ivoa.www.xml.VODataService.v0_5.ScalarDataType.fromString(value);
    }

    // Simple Types must have a toString for serializing the value
    public java.lang.String toString() {
        return value == null ? null : value.toString();
    }


    /**
     * Gets the value value for this DataType.
     * 
     * @return value
     */
    public net.ivoa.www.xml.VODataService.v0_5.ScalarDataType getValue() {
        return value;
    }


    /**
     * Sets the value value for this DataType.
     * 
     * @param value
     */
    public void setValue(net.ivoa.www.xml.VODataService.v0_5.ScalarDataType value) {
        this.value = value;
    }


    /**
     * Gets the arraysize value for this DataType.
     * 
     * @return arraysize
     */
    public org.apache.axis.types.Token getArraysize() {
        return arraysize;
    }


    /**
     * Sets the arraysize value for this DataType.
     * 
     * @param arraysize
     */
    public void setArraysize(org.apache.axis.types.Token arraysize) {
        this.arraysize = arraysize;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof DataType)) return false;
        DataType other = (DataType) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.value==null && other.getValue()==null) || 
             (this.value!=null &&
              this.value.equals(other.getValue()))) &&
            ((this.arraysize==null && other.getArraysize()==null) || 
             (this.arraysize!=null &&
              this.arraysize.equals(other.getArraysize())));
        __equalsCalc = null;
        return _equals;
    }

    private boolean __hashCodeCalc = false;
    public synchronized int hashCode() {
        if (__hashCodeCalc) {
            return 0;
        }
        __hashCodeCalc = true;
        int _hashCode = 1;
        if (getValue() != null) {
            _hashCode += getValue().hashCode();
        }
        if (getArraysize() != null) {
            _hashCode += getArraysize().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(DataType.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VODataService/v0.5", "DataType"));
        org.apache.axis.description.AttributeDesc attrField = new org.apache.axis.description.AttributeDesc();
        attrField.setFieldName("arraysize");
        attrField.setXmlName(new javax.xml.namespace.QName("", "arraysize"));
        attrField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "token"));
        typeDesc.addFieldDesc(attrField);
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("value");
        elemField.setXmlName(new javax.xml.namespace.QName("", "value"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VODataService/v0.5", "ScalarDataType"));
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
          new  org.apache.axis.encoding.ser.SimpleSerializer(
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
          new  org.apache.axis.encoding.ser.SimpleDeserializer(
            _javaType, _xmlType, typeDesc);
    }

}
