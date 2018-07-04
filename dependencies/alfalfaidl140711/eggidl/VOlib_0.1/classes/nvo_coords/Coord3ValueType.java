/**
 * Coord3ValueType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package nvo_coords;

public class Coord3ValueType  implements java.io.Serializable {
    private nvo_coords.ArrayOfDouble value;
    private org.apache.axis.types.IDRefs reference;
    private nvo_coords.PosUnitType pos1_unit;  // attribute
    private nvo_coords.PosUnitType pos2_unit;  // attribute
    private nvo_coords.PosUnitType pos3_unit;  // attribute

    public Coord3ValueType() {
    }


    /**
     * Gets the value value for this Coord3ValueType.
     * 
     * @return value
     */
    public nvo_coords.ArrayOfDouble getValue() {
        return value;
    }


    /**
     * Sets the value value for this Coord3ValueType.
     * 
     * @param value
     */
    public void setValue(nvo_coords.ArrayOfDouble value) {
        this.value = value;
    }


    /**
     * Gets the reference value for this Coord3ValueType.
     * 
     * @return reference
     */
    public org.apache.axis.types.IDRefs getReference() {
        return reference;
    }


    /**
     * Sets the reference value for this Coord3ValueType.
     * 
     * @param reference
     */
    public void setReference(org.apache.axis.types.IDRefs reference) {
        this.reference = reference;
    }


    /**
     * Gets the pos1_unit value for this Coord3ValueType.
     * 
     * @return pos1_unit
     */
    public nvo_coords.PosUnitType getPos1_unit() {
        return pos1_unit;
    }


    /**
     * Sets the pos1_unit value for this Coord3ValueType.
     * 
     * @param pos1_unit
     */
    public void setPos1_unit(nvo_coords.PosUnitType pos1_unit) {
        this.pos1_unit = pos1_unit;
    }


    /**
     * Gets the pos2_unit value for this Coord3ValueType.
     * 
     * @return pos2_unit
     */
    public nvo_coords.PosUnitType getPos2_unit() {
        return pos2_unit;
    }


    /**
     * Sets the pos2_unit value for this Coord3ValueType.
     * 
     * @param pos2_unit
     */
    public void setPos2_unit(nvo_coords.PosUnitType pos2_unit) {
        this.pos2_unit = pos2_unit;
    }


    /**
     * Gets the pos3_unit value for this Coord3ValueType.
     * 
     * @return pos3_unit
     */
    public nvo_coords.PosUnitType getPos3_unit() {
        return pos3_unit;
    }


    /**
     * Sets the pos3_unit value for this Coord3ValueType.
     * 
     * @param pos3_unit
     */
    public void setPos3_unit(nvo_coords.PosUnitType pos3_unit) {
        this.pos3_unit = pos3_unit;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof Coord3ValueType)) return false;
        Coord3ValueType other = (Coord3ValueType) obj;
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
            ((this.reference==null && other.getReference()==null) || 
             (this.reference!=null &&
              this.reference.equals(other.getReference()))) &&
            ((this.pos1_unit==null && other.getPos1_unit()==null) || 
             (this.pos1_unit!=null &&
              this.pos1_unit.equals(other.getPos1_unit()))) &&
            ((this.pos2_unit==null && other.getPos2_unit()==null) || 
             (this.pos2_unit!=null &&
              this.pos2_unit.equals(other.getPos2_unit()))) &&
            ((this.pos3_unit==null && other.getPos3_unit()==null) || 
             (this.pos3_unit!=null &&
              this.pos3_unit.equals(other.getPos3_unit())));
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
        if (getReference() != null) {
            _hashCode += getReference().hashCode();
        }
        if (getPos1_unit() != null) {
            _hashCode += getPos1_unit().hashCode();
        }
        if (getPos2_unit() != null) {
            _hashCode += getPos2_unit().hashCode();
        }
        if (getPos3_unit() != null) {
            _hashCode += getPos3_unit().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(Coord3ValueType.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("urn:nvo-coords", "coord3ValueType"));
        org.apache.axis.description.AttributeDesc attrField = new org.apache.axis.description.AttributeDesc();
        attrField.setFieldName("pos1_unit");
        attrField.setXmlName(new javax.xml.namespace.QName("", "pos1_unit"));
        attrField.setXmlType(new javax.xml.namespace.QName("urn:nvo-coords", "posUnitType"));
        typeDesc.addFieldDesc(attrField);
        attrField = new org.apache.axis.description.AttributeDesc();
        attrField.setFieldName("pos2_unit");
        attrField.setXmlName(new javax.xml.namespace.QName("", "pos2_unit"));
        attrField.setXmlType(new javax.xml.namespace.QName("urn:nvo-coords", "posUnitType"));
        typeDesc.addFieldDesc(attrField);
        attrField = new org.apache.axis.description.AttributeDesc();
        attrField.setFieldName("pos3_unit");
        attrField.setXmlName(new javax.xml.namespace.QName("", "pos3_unit"));
        attrField.setXmlType(new javax.xml.namespace.QName("urn:nvo-coords", "posUnitType"));
        typeDesc.addFieldDesc(attrField);
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("value");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:nvo-coords", "Value"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:nvo-coords", "ArrayOfDouble"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("reference");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:nvo-coords", "Reference"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "IDREFS"));
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
