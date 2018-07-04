/**
 * ConvexHullType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package nvo_region;

public class ConvexHullType  extends nvo_region.ShapeType  implements java.io.Serializable {
    private nvo_coords.CoordsType[] point;

    public ConvexHullType() {
    }


    /**
     * Gets the point value for this ConvexHullType.
     * 
     * @return point
     */
    public nvo_coords.CoordsType[] getPoint() {
        return point;
    }


    /**
     * Sets the point value for this ConvexHullType.
     * 
     * @param point
     */
    public void setPoint(nvo_coords.CoordsType[] point) {
        this.point = point;
    }

    public nvo_coords.CoordsType getPoint(int i) {
        return this.point[i];
    }

    public void setPoint(int i, nvo_coords.CoordsType value) {
        this.point[i] = value;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof ConvexHullType)) return false;
        ConvexHullType other = (ConvexHullType) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = super.equals(obj) && 
            ((this.point==null && other.getPoint()==null) || 
             (this.point!=null &&
              java.util.Arrays.equals(this.point, other.getPoint())));
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
        if (getPoint() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getPoint());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getPoint(), i);
                if (obj != null &&
                    !obj.getClass().isArray()) {
                    _hashCode += obj.hashCode();
                }
            }
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(ConvexHullType.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("urn:nvo-region", "convexHullType"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("point");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:nvo-region", "Point"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:nvo-coords", "coordsType"));
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
