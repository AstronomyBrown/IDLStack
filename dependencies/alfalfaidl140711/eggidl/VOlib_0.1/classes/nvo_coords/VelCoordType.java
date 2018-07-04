/**
 * VelCoordType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package nvo_coords;

public abstract class VelCoordType  implements java.io.Serializable {
    private java.lang.String name;
    private nvo_coords.VelTimeUnitType vel_time_unit;  // attribute

    public VelCoordType() {
    }


    /**
     * Gets the name value for this VelCoordType.
     * 
     * @return name
     */
    public java.lang.String getName() {
        return name;
    }


    /**
     * Sets the name value for this VelCoordType.
     * 
     * @param name
     */
    public void setName(java.lang.String name) {
        this.name = name;
    }


    /**
     * Gets the vel_time_unit value for this VelCoordType.
     * 
     * @return vel_time_unit
     */
    public nvo_coords.VelTimeUnitType getVel_time_unit() {
        return vel_time_unit;
    }


    /**
     * Sets the vel_time_unit value for this VelCoordType.
     * 
     * @param vel_time_unit
     */
    public void setVel_time_unit(nvo_coords.VelTimeUnitType vel_time_unit) {
        this.vel_time_unit = vel_time_unit;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof VelCoordType)) return false;
        VelCoordType other = (VelCoordType) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.name==null && other.getName()==null) || 
             (this.name!=null &&
              this.name.equals(other.getName()))) &&
            ((this.vel_time_unit==null && other.getVel_time_unit()==null) || 
             (this.vel_time_unit!=null &&
              this.vel_time_unit.equals(other.getVel_time_unit())));
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
        if (getName() != null) {
            _hashCode += getName().hashCode();
        }
        if (getVel_time_unit() != null) {
            _hashCode += getVel_time_unit().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(VelCoordType.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("urn:nvo-coords", "velCoordType"));
        org.apache.axis.description.AttributeDesc attrField = new org.apache.axis.description.AttributeDesc();
        attrField.setFieldName("vel_time_unit");
        attrField.setXmlName(new javax.xml.namespace.QName("", "vel_time_unit"));
        attrField.setXmlType(new javax.xml.namespace.QName("urn:nvo-coords", "velTimeUnitType"));
        typeDesc.addFieldDesc(attrField);
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("name");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:nvo-coords", "Name"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
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
