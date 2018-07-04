/**
 * CoordValueType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package nvo_coords;

public class CoordValueType  implements java.io.Serializable {
    private double value;
    private java.lang.String value60;
    private org.apache.axis.types.IDRef reference;
    private nvo_coords.PosUnitType pos_unit;  // attribute

    public CoordValueType() {
    }


    /**
     * Gets the value value for this CoordValueType.
     * 
     * @return value
     */
    public double getValue() {
        return value;
    }


    /**
     * Sets the value value for this CoordValueType.
     * 
     * @param value
     */
    public void setValue(double value) {
        this.value = value;
    }


    /**
     * Gets the value60 value for this CoordValueType.
     * 
     * @return value60
     */
    public java.lang.String getValue60() {
        return value60;
    }


    /**
     * Sets the value60 value for this CoordValueType.
     * 
     * @param value60
     */
    public void setValue60(java.lang.String value60) {
        this.value60 = value60;
    }


    /**
     * Gets the reference value for this CoordValueType.
     * 
     * @return reference
     */
    public org.apache.axis.types.IDRef getReference() {
        return reference;
    }


    /**
     * Sets the reference value for this CoordValueType.
     * 
     * @param reference
     */
    public void setReference(org.apache.axis.types.IDRef reference) {
        this.reference = reference;
    }


    /**
     * Gets the pos_unit value for this CoordValueType.
     * 
     * @return pos_unit
     */
    public nvo_coords.PosUnitType getPos_unit() {
        return pos_unit;
    }


    /**
     * Sets the pos_unit value for this CoordValueType.
     * 
     * @param pos_unit
     */
    public void setPos_unit(nvo_coords.PosUnitType pos_unit) {
        this.pos_unit = pos_unit;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof CoordValueType)) return false;
        CoordValueType other = (CoordValueType) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            this.value == other.getValue() &&
            ((this.value60==null && other.getValue60()==null) || 
             (this.value60!=null &&
              this.value60.equals(other.getValue60()))) &&
            ((this.reference==null && other.getReference()==null) || 
             (this.reference!=null &&
              this.reference.equals(other.getReference()))) &&
            ((this.pos_unit==null && other.getPos_unit()==null) || 
             (this.pos_unit!=null &&
              this.pos_unit.equals(other.getPos_unit())));
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
        _hashCode += new Double(getValue()).hashCode();
        if (getValue60() != null) {
            _hashCode += getValue60().hashCode();
        }
        if (getReference() != null) {
            _hashCode += getReference().hashCode();
        }
        if (getPos_unit() != null) {
            _hashCode += getPos_unit().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(CoordValueType.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("urn:nvo-coords", "coordValueType"));
        org.apache.axis.description.AttributeDesc attrField = new org.apache.axis.description.AttributeDesc();
        attrField.setFieldName("pos_unit");
        attrField.setXmlName(new javax.xml.namespace.QName("", "pos_unit"));
        attrField.setXmlType(new javax.xml.namespace.QName("urn:nvo-coords", "posUnitType"));
        typeDesc.addFieldDesc(attrField);
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("value");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:nvo-coords", "Value"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "double"));
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("value60");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:nvo-coords", "Value60"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("reference");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:nvo-coords", "Reference"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "IDREF"));
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
