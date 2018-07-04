/**
 * CoordRange.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package net.ivoa.www.xml.VODataService.v0_5;

public class CoordRange  extends net.ivoa.www.xml.VODataService.v0_5.Region  implements java.io.Serializable {
    private net.ivoa.www.xml.VODataService.v0_5.CoordFrame coordFrame;
    private net.ivoa.www.xml.VODataService.v0_5.AngleRange _long;
    private net.ivoa.www.xml.VODataService.v0_5.AngleRange lat;

    public CoordRange() {
    }


    /**
     * Gets the coordFrame value for this CoordRange.
     * 
     * @return coordFrame
     */
    public net.ivoa.www.xml.VODataService.v0_5.CoordFrame getCoordFrame() {
        return coordFrame;
    }


    /**
     * Sets the coordFrame value for this CoordRange.
     * 
     * @param coordFrame
     */
    public void setCoordFrame(net.ivoa.www.xml.VODataService.v0_5.CoordFrame coordFrame) {
        this.coordFrame = coordFrame;
    }


    /**
     * Gets the _long value for this CoordRange.
     * 
     * @return _long
     */
    public net.ivoa.www.xml.VODataService.v0_5.AngleRange get_long() {
        return _long;
    }


    /**
     * Sets the _long value for this CoordRange.
     * 
     * @param _long
     */
    public void set_long(net.ivoa.www.xml.VODataService.v0_5.AngleRange _long) {
        this._long = _long;
    }


    /**
     * Gets the lat value for this CoordRange.
     * 
     * @return lat
     */
    public net.ivoa.www.xml.VODataService.v0_5.AngleRange getLat() {
        return lat;
    }


    /**
     * Sets the lat value for this CoordRange.
     * 
     * @param lat
     */
    public void setLat(net.ivoa.www.xml.VODataService.v0_5.AngleRange lat) {
        this.lat = lat;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof CoordRange)) return false;
        CoordRange other = (CoordRange) obj;
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
            ((this._long==null && other.get_long()==null) || 
             (this._long!=null &&
              this._long.equals(other.get_long()))) &&
            ((this.lat==null && other.getLat()==null) || 
             (this.lat!=null &&
              this.lat.equals(other.getLat())));
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
        if (get_long() != null) {
            _hashCode += get_long().hashCode();
        }
        if (getLat() != null) {
            _hashCode += getLat().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(CoordRange.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VODataService/v0.5", "CoordRange"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("coordFrame");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VODataService/v0.5", "coordFrame"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VODataService/v0.5", "CoordFrame"));
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("_long");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VODataService/v0.5", "long"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VODataService/v0.5", "AngleRange"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("lat");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VODataService/v0.5", "lat"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VODataService/v0.5", "AngleRange"));
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
