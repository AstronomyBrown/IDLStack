/**
 * Waveband.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package net.ivoa.www.xml.VODataService.v0_5;

public class Waveband implements java.io.Serializable {
    private java.lang.String _value_;
    private static java.util.HashMap _table_ = new java.util.HashMap();

    // Constructor
    protected Waveband(java.lang.String value) {
        _value_ = value;
        _table_.put(_value_,this);
    }

    public static final java.lang.String _value1 = "Radio";
    public static final java.lang.String _value2 = "Millimeter";
    public static final java.lang.String _value3 = "Infrared";
    public static final java.lang.String _value4 = "Optical";
    public static final java.lang.String _value5 = "UV";
    public static final java.lang.String _value6 = "EUV";
    public static final java.lang.String _value7 = "X-ray";
    public static final java.lang.String _value8 = "Gamma-ray";
    public static final Waveband value1 = new Waveband(_value1);
    public static final Waveband value2 = new Waveband(_value2);
    public static final Waveband value3 = new Waveband(_value3);
    public static final Waveband value4 = new Waveband(_value4);
    public static final Waveband value5 = new Waveband(_value5);
    public static final Waveband value6 = new Waveband(_value6);
    public static final Waveband value7 = new Waveband(_value7);
    public static final Waveband value8 = new Waveband(_value8);
    public java.lang.String getValue() { return _value_;}
    public static Waveband fromValue(java.lang.String value)
          throws java.lang.IllegalArgumentException {
        Waveband enumeration = (Waveband)
            _table_.get(value);
        if (enumeration==null) throw new java.lang.IllegalArgumentException();
        return enumeration;
    }
    public static Waveband fromString(java.lang.String value)
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
        new org.apache.axis.description.TypeDesc(Waveband.class);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VODataService/v0.5", "Waveband"));
    }
    /**
     * Return type metadata object
     */
    public static org.apache.axis.description.TypeDesc getTypeDesc() {
        return typeDesc;
    }

}
