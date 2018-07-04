/**
 * DataType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package fr.u_strasbg.vizier.xml.VOTable_1_1_xsd;

public class DataType implements java.io.Serializable {
    private java.lang.String _value_;
    private static java.util.HashMap _table_ = new java.util.HashMap();

    // Constructor
    protected DataType(java.lang.String value) {
        _value_ = value;
        _table_.put(_value_,this);
    }

    public static final java.lang.String _value1 = "boolean";
    public static final java.lang.String _value2 = "bit";
    public static final java.lang.String _value3 = "unsignedByte";
    public static final java.lang.String _value4 = "short";
    public static final java.lang.String _value5 = "int";
    public static final java.lang.String _value6 = "long";
    public static final java.lang.String _value7 = "char";
    public static final java.lang.String _value8 = "unicodeChar";
    public static final java.lang.String _value9 = "float";
    public static final java.lang.String _value10 = "double";
    public static final java.lang.String _value11 = "floatComplex";
    public static final java.lang.String _value12 = "doubleComplex";
    public static final DataType value1 = new DataType(_value1);
    public static final DataType value2 = new DataType(_value2);
    public static final DataType value3 = new DataType(_value3);
    public static final DataType value4 = new DataType(_value4);
    public static final DataType value5 = new DataType(_value5);
    public static final DataType value6 = new DataType(_value6);
    public static final DataType value7 = new DataType(_value7);
    public static final DataType value8 = new DataType(_value8);
    public static final DataType value9 = new DataType(_value9);
    public static final DataType value10 = new DataType(_value10);
    public static final DataType value11 = new DataType(_value11);
    public static final DataType value12 = new DataType(_value12);
    public java.lang.String getValue() { return _value_;}
    public static DataType fromValue(java.lang.String value)
          throws java.lang.IllegalArgumentException {
        DataType enumeration = (DataType)
            _table_.get(value);
        if (enumeration==null) throw new java.lang.IllegalArgumentException();
        return enumeration;
    }
    public static DataType fromString(java.lang.String value)
          throws java.lang.IllegalArgumentException {
        return fromValue(value);
    }
    public boolean equals(java.lang.Object obj) {return (obj == this);}
    public int hashCode() { return toString().hashCode();}
    public java.lang.String toString() { return _value_;}
    public java.lang.Object readResolve() throws java.io.ObjectStreamException { return fromValue(_value_);}
    public static org.apache.axis.encoding.Serializer getSerializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new org.apache.axis.encoding.ser.EnumSerializer(
            _javaType, _xmlType);
    }
    public static org.apache.axis.encoding.Deserializer getDeserializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new org.apache.axis.encoding.ser.EnumDeserializer(
            _javaType, _xmlType);
    }
    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(DataType.class);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "dataType"));
    }
    /**
     * Return type metadata object
     */
    public static org.apache.axis.description.TypeDesc getTypeDesc() {
        return typeDesc;
    }

}
