/**
 * CircleRegion.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package net.ivoa.www.xml.VODataService.v0_5;

public class CircleRegion  extends net.ivoa.www.xml.VODataService.v0_5.Region  implements java.io.Serializable {
    private net.ivoa.www.xml.VODataService.v0_5.CoordFrame coordFrame;
    private net.ivoa.www.xml.VODataService.v0_5.Position center;
    private float radius;

    public CircleRegion() {
    }


    /**
     * Gets the coordFrame value for this CircleRegion.
     * 
     * @return coordFrame
     */
    public net.ivoa.www.xml.VODataService.v0_5.CoordFrame getCoordFrame() {
        return coordFrame;
    }


    /**
     * Sets the coordFrame value for this CircleRegion.
     * 
     * @param coordFrame
     */
    public void setCoordFrame(net.ivoa.www.xml.VODataService.v0_5.CoordFrame coordFrame) {
        this.coordFrame = coordFrame;
    }


    /**
     * Gets the center value for this CircleRegion.
     * 
     * @return center
     */
    public net.ivoa.www.xml.VODataService.v0_5.Position getCenter() {
        return center;
    }


    /**
     * Sets the center value for this CircleRegion.
     * 
     * @param center
     */
    public void setCenter(net.ivoa.www.xml.VODataService.v0_5.Position center) {
        this.center = center;
    }


    /**
     * Gets the radius value for this CircleRegion.
     * 
     * @return radius
     */
    public float getRadius() {
        return radius;
    }


    /**
     * Sets the radius value for this CircleRegion.
     * 
     * @param radius
     */
    public void setRadius(float radius) {
        this.radius = radius;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof CircleRegion)) return false;
        CircleRegion other = (CircleRegion) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = super.equals(obj) && 
            ((this.coordFrame==null && other.getCoordFrame()==null) || 
             (this.coordFrame!=null &&
              this.coordFrame.equals(other.getCoordFrame()))) &&
            ((this.center==null && other.getCenter()==null) || 
             (this.center!=null &&
              this.center.equals(other.getCenter()))) &&
            this.radius == other.getRadius();
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
        if (getCoordFrame() != null) {
            _hashCode += getCoordFrame().hashCode();
        }
        if (getCenter() != null) {
            _hashCode += getCenter().hashCode();
        }
        _hashCode += new Float(getRadius()).hashCode();
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(CircleRegion.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VODataService/v0.5", "CircleRegion"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("coordFrame");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VODataService/v0.5", "coordFrame"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VODataService/v0.5", "CoordFrame"));
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("center");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VODataService/v0.5", "center"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VODataService/v0.5", "Position"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("radius");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VODataService/v0.5", "radius"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "float"));
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
