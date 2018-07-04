/**
 * VertexType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package nvo_region;

public class VertexType  implements java.io.Serializable {
    private nvo_coords.CoordsType position;
    private nvo_region.SmallCircleType smallCircle;

    public VertexType() {
    }


    /**
     * Gets the position value for this VertexType.
     * 
     * @return position
     */
    public nvo_coords.CoordsType getPosition() {
        return position;
    }


    /**
     * Sets the position value for this VertexType.
     * 
     * @param position
     */
    public void setPosition(nvo_coords.CoordsType position) {
        this.position = position;
    }


    /**
     * Gets the smallCircle value for this VertexType.
     * 
     * @return smallCircle
     */
    public nvo_region.SmallCircleType getSmallCircle() {
        return smallCircle;
    }


    /**
     * Sets the smallCircle value for this VertexType.
     * 
     * @param smallCircle
     */
    public void setSmallCircle(nvo_region.SmallCircleType smallCircle) {
        this.smallCircle = smallCircle;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof VertexType)) return false;
        VertexType other = (VertexType) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.position==null && other.getPosition()==null) || 
             (this.position!=null &&
              this.position.equals(other.getPosition()))) &&
            ((this.smallCircle==null && other.getSmallCircle()==null) || 
             (this.smallCircle!=null &&
              this.smallCircle.equals(other.getSmallCircle())));
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
        if (getPosition() != null) {
            _hashCode += getPosition().hashCode();
        }
        if (getSmallCircle() != null) {
            _hashCode += getSmallCircle().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(VertexType.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("urn:nvo-region", "vertexType"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("position");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:nvo-region", "Position"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:nvo-coords", "coordsType"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("smallCircle");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:nvo-region", "SmallCircle"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:nvo-region", "smallCircleType"));
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
