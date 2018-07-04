/**
 * CoordTimeValueType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package nvo_coords;

public class CoordTimeValueType  implements java.io.Serializable {
    private double value;
    private org.apache.axis.types.IDRef reference;
    private nvo_coords.VelTimeUnitType time_unit;  // attribute

    public CoordTimeValueType() {
    }


    /**
     * Gets the value value for this CoordTimeValueType.
     * 
     * @return value
     */
    public double getValue() {
        return value;
    }


    /**
     * Sets the value value for this CoordTimeValueType.
     * 
     * @param value
     */
    public void setValue(double value) {
        this.value = value;
    }


    /**
     * Gets the reference value for this CoordTimeValueType.
     * 
     * @return reference
     */
    public org.apache.axis.types.IDRef getReference() {
        return reference;
    }


    /**
     * Sets the reference value for this CoordTimeValueType.
     * 
     * @param reference
     */
    public void setReference(org.apache.axis.types.IDRef reference) {
        this.reference = reference;
    }


    /**
     * Gets the time_unit value for this CoordTimeValueType.
     * 
     * @return time_unit
     */
    public nvo_coords.VelTimeUnitType getTime_unit() {
        return time_unit;
    }


    /**
     * Sets the time_unit value for this CoordTimeValueType.
     * 
     * @param time_unit
     */
    public void setTime_unit(nvo_coords.VelTimeUnitType time_unit) {
        this.time_unit = time_unit;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof CoordTimeValueType)) return false;
        CoordTimeValueType other = (CoordTimeValueType) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            this.value == other.getValue() &&
            ((this.reference==null && other.getReference()==null) || 
             (this.reference!=null &&
              this.reference.equals(other.getReference()))) &&
            ((this.time_unit==null && other.getTime_unit()==null) || 
             (this.time_unit!=null &&
              this.time_unit.equals(other.getTime_unit())));
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
        if (getReference() != null) {
            _hashCode += getReference().hashCode();
        }
        if (getTime_unit() != null) {
            _hashCode += getTime_unit().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(CoordTimeValueType.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("urn:nvo-coords", "coordTimeValueType"));
        org.apache.axis.description.AttributeDesc attrField = new org.apache.axis.description.AttributeDesc();
        attrField.setFieldName("time_unit");
        attrField.setXmlName(new javax.xml.namespace.QName("", "time_unit"));
        attrField.setXmlType(new javax.xml.namespace.QName("urn:nvo-coords", "velTimeUnitType"));
        typeDesc.addFieldDesc(attrField);
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("value");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:nvo-coords", "Value"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "double"));
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
