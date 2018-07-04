/**
 * SpectralUnitType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package nvo_coords;

public class SpectralUnitType implements java.io.Serializable {
    private java.lang.String _value_;
    private static java.util.HashMap _table_ = new java.util.HashMap();

    // Constructor
    protected SpectralUnitType(java.lang.String value) {
        _value_ = value;
        _table_.put(_value_,this);
    }

    public static final java.lang.String _Hz = "Hz";
    public static final java.lang.String _kHz = "kHz";
    public static final java.lang.String _MHz = "MHz";
    public static final java.lang.String _GHz = "GHz";
    public static final java.lang.String _m = "m";
    public static final java.lang.String _mm = "mm";
    public static final java.lang.String _micron = "micron";
    public static final java.lang.String _nm = "nm";
    public static final java.lang.String _A = "A";
    public static final java.lang.String _eV = "eV";
    public static final java.lang.String _keV = "keV";
    public static final java.lang.String _MeV = "MeV";
    public static final java.lang.String _GeV = "GeV";
    public static final SpectralUnitType Hz = new SpectralUnitType(_Hz);
    public static final SpectralUnitType kHz = new SpectralUnitType(_kHz);
    public static final SpectralUnitType MHz = new SpectralUnitType(_MHz);
    public static final SpectralUnitType GHz = new SpectralUnitType(_GHz);
    public static final SpectralUnitType m = new SpectralUnitType(_m);
    public static final SpectralUnitType mm = new SpectralUnitType(_mm);
    public static final SpectralUnitType micron = new SpectralUnitType(_micron);
    public static final SpectralUnitType nm = new SpectralUnitType(_nm);
    public static final SpectralUnitType A = new SpectralUnitType(_A);
    public static final SpectralUnitType eV = new SpectralUnitType(_eV);
    public static final SpectralUnitType keV = new SpectralUnitType(_keV);
    public static final SpectralUnitType MeV = new SpectralUnitType(_MeV);
    public static final SpectralUnitType GeV = new SpectralUnitType(_GeV);
    public java.lang.String getValue() { return _value_;}
    public static SpectralUnitType fromValue(java.lang.String value)
          throws java.lang.IllegalArgumentException {
        SpectralUnitType enumeration = (SpectralUnitType)
            _table_.get(value);
        if (enumeration==null) throw new java.lang.IllegalArgumentException();
        return enumeration;
    }
    public static SpectralUnitType fromString(java.lang.String value)
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
        new org.apache.axis.description.TypeDesc(SpectralUnitType.class);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("urn:nvo-coords", "spectralUnitType"));
    }
    /**
     * Return type metadata object
     */
    public static org.apache.axis.description.TypeDesc getTypeDesc() {
        return typeDesc;
    }

}
