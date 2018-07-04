/**
 * AstronTimeTypeReference.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package nvo_coords;

public class AstronTimeTypeReference  implements java.io.Serializable, org.apache.axis.encoding.SimpleType {
    private org.apache.axis.types.IDRef value;
    private nvo_coords.AstronTimeTypeReferenceTime_base time_base;  // attribute
    private nvo_coords.AstronTimeTypeReferenceUnit unit;  // attribute

    public AstronTimeTypeReference() {
    }

    // Simple Types must have a String constructor
    public AstronTimeTypeReference(org.apache.axis.types.IDRef value) {
        this.value = value;
    }
    public AstronTimeTypeReference(java.lang.String value) {
        this.value = new org.apache.axis.types.IDRef(value);
    }

    // Simple Types must have a toString for serializing the value
    public java.lang.String toString() {
        return value == null ? null : value.toString();
    }


    /**
     * Gets the value value for this AstronTimeTypeReference.
     * 
     * @return value
     */
    public org.apache.axis.types.IDRef getValue() {
        return value;
    }


    /**
     * Sets the value value for this AstronTimeTypeReference.
     * 
     * @param value
     */
    public void setValue(org.apache.axis.types.IDRef value) {
        this.value = value;
    }


    /**
     * Gets the time_base value for this AstronTimeTypeReference.
     * 
     * @return time_base
     */
    public nvo_coords.AstronTimeTypeReferenceTime_base getTime_base() {
        return time_base;
    }


    /**
     * Sets the time_base value for this AstronTimeTypeReference.
     * 
     * @param time_base
     */
    public void setTime_base(nvo_coords.AstronTimeTypeReferenceTime_base time_base) {
        this.time_base = time_base;
    }


    /**
     * Gets the unit value for this AstronTimeTypeReference.
     * 
     * @return unit
     */
    public nvo_coords.AstronTimeTypeReferenceUnit getUnit() {
        return unit;
    }


    /**
     * Sets the unit value for this AstronTimeTypeReference.
     * 
     * @param unit
     */
    public void setUnit(nvo_coords.AstronTimeTypeReferenceUnit unit) {
        this.unit = unit;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof AstronTimeTypeReference)) return false;
        AstronTimeTypeReference other = (AstronTimeTypeReference) obj;
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
            ((this.time_base==null && other.getTime_base()==null) || 
             (this.time_base!=null &&
              this.time_base.equals(other.getTime_base()))) &&
            ((this.unit==null && other.getUnit()==null) || 
             (this.unit!=null &&
              this.unit.equals(other.getUnit())));
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
        if (getTime_base() != null) {
            _hashCode += getTime_base().hashCode();
        }
        if (getUnit() != null) {
            _hashCode += getUnit().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(AstronTimeTypeReference.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("urn:nvo-coords", "astronTimeTypeReference"));
        org.apache.axis.description.AttributeDesc attrField = new org.apache.axis.description.AttributeDesc();
        attrField.setFieldName("time_base");
        attrField.setXmlName(new javax.xml.namespace.QName("", "time_base"));
        attrField.setXmlType(new javax.xml.namespace.QName("urn:nvo-coords", "astronTimeTypeReferenceTime_base"));
        typeDesc.addFieldDesc(attrField);
        attrField = new org.apache.axis.description.AttributeDesc();
        attrField.setFieldName("unit");
        attrField.setXmlName(new javax.xml.namespace.QName("", "unit"));
        attrField.setXmlType(new javax.xml.namespace.QName("urn:nvo-coords", "astronTimeTypeReferenceUnit"));
        typeDesc.addFieldDesc(attrField);
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("value");
        elemField.setXmlName(new javax.xml.namespace.QName("", "value"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "IDREF"));
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
