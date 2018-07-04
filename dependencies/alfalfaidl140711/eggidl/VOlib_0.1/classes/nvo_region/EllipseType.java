/**
 * EllipseType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package nvo_region;

public class EllipseType  extends nvo_region.CircleType  implements java.io.Serializable {
    private double minorRadius;
    private double posAngle;
    private nvo_coords.AngleUnitType pos_angle_unit;  // attribute

    public EllipseType() {
    }


    /**
     * Gets the minorRadius value for this EllipseType.
     * 
     * @return minorRadius
     */
    public double getMinorRadius() {
        return minorRadius;
    }


    /**
     * Sets the minorRadius value for this EllipseType.
     * 
     * @param minorRadius
     */
    public void setMinorRadius(double minorRadius) {
        this.minorRadius = minorRadius;
    }


    /**
     * Gets the posAngle value for this EllipseType.
     * 
     * @return posAngle
     */
    public double getPosAngle() {
        return posAngle;
    }


    /**
     * Sets the posAngle value for this EllipseType.
     * 
     * @param posAngle
     */
    public void setPosAngle(double posAngle) {
        this.posAngle = posAngle;
    }


    /**
     * Gets the pos_angle_unit value for this EllipseType.
     * 
     * @return pos_angle_unit
     */
    public nvo_coords.AngleUnitType getPos_angle_unit() {
        return pos_angle_unit;
    }


    /**
     * Sets the pos_angle_unit value for this EllipseType.
     * 
     * @param pos_angle_unit
     */
    public void setPos_angle_unit(nvo_coords.AngleUnitType pos_angle_unit) {
        this.pos_angle_unit = pos_angle_unit;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof EllipseType)) return false;
        EllipseType other = (EllipseType) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = super.equals(obj) && 
            this.minorRadius == other.getMinorRadius() &&
            this.posAngle == other.getPosAngle() &&
            ((this.pos_angle_unit==null && other.getPos_angle_unit()==null) || 
             (this.pos_angle_unit!=null &&
              this.pos_angle_unit.equals(other.getPos_angle_unit())));
        __equalsCalc = null;
        return _equals;
    }

    private boolean __hashCodeCalc = false;
    public synchronized int hashCode() {
        if (__hashCodeCalc) {
            return 0;
        }
        __hashCodeCalc = true;
        int _hashCode = super.hashCode();
        _hashCode += new Double(getMinorRadius()).hashCode();
        _hashCode += new Double(getPosAngle()).hashCode();
        if (getPos_angle_unit() != null) {
            _hashCode += getPos_angle_unit().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(EllipseType.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("urn:nvo-region", "ellipseType"));
        org.apache.axis.description.AttributeDesc attrField = new org.apache.axis.description.AttributeDesc();
        attrField.setFieldName("pos_angle_unit");
        attrField.setXmlName(new javax.xml.namespace.QName("", "pos_angle_unit"));
        attrField.setXmlType(new javax.xml.namespace.QName("urn:nvo-coords", "angleUnitType"));
        typeDesc.addFieldDesc(attrField);
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("minorRadius");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:nvo-region", "MinorRadius"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "double"));
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("posAngle");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:nvo-region", "PosAngle"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "double"));
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
