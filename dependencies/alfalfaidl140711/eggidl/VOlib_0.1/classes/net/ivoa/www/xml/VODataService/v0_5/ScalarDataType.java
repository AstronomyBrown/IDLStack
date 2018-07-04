/**
 * ScalarDataType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package net.ivoa.www.xml.VODataService.v0_5;

public class ScalarDataType implements java.io.Serializable {
    private java.lang.String _value_;
    private static java.util.HashMap _table_ = new java.util.HashMap();

    // Constructor
    protected ScalarDataType(java.lang.String value) {
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
    public static final ScalarDataType value1 = new ScalarDataType(_value1);
    public static final ScalarDataType value2 = new ScalarDataType(_value2);
    public static final ScalarDataType value3 = new ScalarDataType(_value3);
    public static final ScalarDataType value4 = new ScalarDataType(_value4);
    public static final ScalarDataType value5 = new ScalarDataType(_value5);
    public static final ScalarDataType value6 = new ScalarDataType(_value6);
    public static final ScalarDataType value7 = new ScalarDataType(_value7);
    public static final ScalarDataType value8 = new ScalarDataType(_value8);
    public static final ScalarDataType value9 = new ScalarDataType(_value9);
    public static final ScalarDataType value10 = new ScalarDataType(_value10);
    public static final ScalarDataType value11 = new ScalarDataType(_value11);
    public static final ScalarDataType value12 = new ScalarDataType(_value12);
    public java.lang.String getValue() { return _value_;}
    public static ScalarDataType fromValue(java.lang.String value)
          throws java.lang.IllegalArgumentException {
        ScalarDataType enumeration = (ScalarDataType)
            _table_.get(value);
        if (enumeration==null) throw new java.lang.IllegalArgumentException();
        return enumeration;
    }
    public static ScalarDataType fromString(java.lang.String value)
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
        new org.apache.axis.description.TypeDesc(ScalarDataType.class);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VODataService/v0.5", "ScalarDataType"));
    }
    /**
     * Return type metadata object
     */
    public static org.apache.axis.description.TypeDesc getTypeDesc() {
        return typeDesc;
    }

}
